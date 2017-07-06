## Copyright (c) 2015, Júlio Hoffimann Mendes <juliohm@stanford.edu>
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

__precompile__(true)

module GeoStats

using Combinatorics: combinations
using SpecialFunctions: besselk
using Parameters: @with_kw
using RecipesBase

include("utils.jl")
include("distances.jl")
include("empirical_variograms.jl")
include("theoretical_variograms.jl")
include("estimators.jl")

# plot recipes
include("plotrecipes/empirical_variograms.jl")
include("plotrecipes/theoretical_variograms.jl")

export
  # distance functions
  EuclideanDistance,
  EllipsoidDistance,
  HaversineDistance,

  # empirical variograms
  EmpiricalVariogram,

  # theoretical variograms
  GaussianVariogram,
  SphericalVariogram,
  ExponentialVariogram,
  MaternVariogram,
  CompositeVariogram,

  # estimators
  SimpleKriging,
  OrdinaryKriging,
  UniversalKriging,

  # functions
  fit!,
  weights,
  estimate

end
