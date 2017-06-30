# vOptSpecific: part of vOptSolver for structured problems

**vOptSolver** is a solver of multiobjective linear optimization problems (MOCO, MOIP, MOMILP, MOLP).
This repository concerns **vOptSpecific**, the part of vOptSolver devoted to **multiobjective structured problems**. With vOptSpecific, the problem is expressed using an Application Programming Interface.

We suppose you are familiar with vOptSolver; if not, read first this [presentation](https://voptsolver.github.io/vOptSolver/).


## Instructions 

### Installation Instructions
For a local use, a working version of:
- Julia must be ready; instructions for the installation are available [here](https://julialang.org/downloads/)
- your favorite C/C++ compiler must be ready (mandatory; GCC is suggested)

Before your first local or distant use, (1) run Julia and when the terminal is ready, (2) add as follow the two mandatory packages to your Julia distribution: 


```julia
julia> Pkg.clone("http://github.com/vOptSolver/vOptSpecific.jl")
julia> Pkg.build("vOptSpecific")
```

That's all folk! 

### Usage Instructions

Install vOptSpecific, and then have fun with the solver. 


## Examples 
Problems ready to be solved and selected datafiles into different formats are provided in the folder `examples`.

