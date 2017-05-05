## Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
##
## Permission to use, copy, modify, and/or distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

@doc doc"""
  Simple Kriging

  *INPUTS*:

    * X  ∈ ℜ^(mxn) - matrix of data locations
    * z  ∈ ℜⁿ      - vector of observations for X
    * cov          - covariance model
    * μ  ∈ ℜ       - mean of z
  """ ->
type SimpleKriging{T<:Real,V} <: AbstractEstimator
  # input fields
  X::AbstractMatrix{T}
  z::AbstractVector{V}
  cov::CovarianceModel
  μ::V

  # state fields
  LU::Base.LinAlg.Factorization{T}

  function SimpleKriging(X, z, cov, μ)
    @assert size(X, 2) == length(z) "incorrect data configuration"
    SK = new(X, z, cov, μ)
    fit!(SK, X)
    SK
  end
end

SimpleKriging(X, z, cov, μ) = SimpleKriging{eltype(X),eltype(z)}(X, z, cov, μ)

function fit!{T<:Real,V}(estimator::SimpleKriging{T,V}, X::AbstractMatrix{T})
  estimator.X = X
  C = pairwise(estimator.cov, X)
  if isposdef(C)
    estimator.LU = cholfact(C)
  else
    estimator.LU = lufact(C)
  end
end

function estimate{T<:Real,V}(estimator::SimpleKriging{T,V}, xₒ::AbstractVector{T})
  X = estimator.X; z = estimator.z
  cov = estimator.cov; μ = estimator.μ
  LU = estimator.LU
  nobs = length(z)

  # evaluate covariance at location
  c = Float64[cov(norm(X[:,j]-xₒ)) for j=1:nobs]

  # solve linear system
  y = z - μ
  λ = LU \ c

  # return estimate and variance
  μ + y⋅λ, cov(0) - c⋅λ
end