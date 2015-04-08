# General principles of software development 

 1. *Iterative, incremental and evolutionary development methods*:
   break tasks into small increments with minimal planning and do not
   directly involve long-term planning. Iterations are short time
   frames (timeboxes) that typically last from one to four weeks. Each
   iteration involves a cross-functional team working in all
   functions: planning, requirements analysis, design, coding, unit
   testing, and acceptance testing. At the end of the iteration a
   working product is demonstrated to stakeholders. This minimizes
   overall risk and allows the project to adapt to changes quickly. An
   iteration might not add enough functionality to warrant a market
   release, but the goal is to have an available release (with minimal
   bugs) at the end of each iteration.

 2. *Code vs. documentation*: documentation should be "Just Barely Good
   Enough" (JBGE) - too much or comprehensive documentation would
   usually cause waste, and developers rarely trust detailed
   documentation because it's usually out of sync with code, while too
   little documentation may also cause problems for maintenance,
   communication, learning and knowledge sharing.

 3. *A module should be open for extension but closed for
   modification*: we should write our modules
so that they can be extended, without requiring them to be modified. In other
words, we want to be able to change what the modules do, without changing the
source code of the modules.

 4. *The granule of reuse is the granule of release*: A large
development project is subdivided into a large network of interelated
packages. The work to manage, test, and release those packages is non-trivial. The more
packages that change in any given release, the greater the work to rebuild, test, and
deploy the release. 

 5. *Depend in the direction of stability*: Stability is related to the
amount of work required to make a change. One sure way to make a software package
difficult to change, is to make lots of other software packages depend upon it. A
package with lots of incoming dependencies is very stable because it requires a
great deal of work to reconcile any changes with all the dependent packages.

# How the principles are implemented in EM-PLUS

## Split between library and project folder (Principles 4., 5., 6.)
The development of EM-PLUS is based on a split between code from the *library* and
code developed under each *project*. These two are kept
in separate folders. The model in the library is a
self-contained model and will be referred to as the *Base Model*. At
the beginning of each project, the project team will start with a
basic working CGE model, which is used in combination with code
created specifically for the project. See the file *sandwichlist.md*
for instructions on how to do so. Code developed in the project can potentially be
merged back into library after a project has finished.

##  Version management (Principle 1.)
Modifications in EM-PLUS should be *incremental* and
*well-documented*, facilitating collaborative code development, making
it easty to synchronise to the common established code base and to
document changes to the code from version to version. The main tool for ensuring proper version
management is GitHub. GitHub is a web-based Git repository hosting service, which offers all
of the distributed revision control and source code management (SCM)
functionality of Git as well as adding its own features. A one page
guide to getting started with GitHub can be found at
http://rogerdudler.github.io/git-guide/

In order to make sure changes are incremental, we would like
developers to accompany commits with a clear description what was changed and why. Avoid committing
whole bundles of unrelated changes with one commit. As a rule of
thumb, commits should not contain more than three major changes.

## Documentation and code (Principle 2.)
Besides formal documentation of the structure (equation), EM-PLUS mainly relies on documentation
within the code itself. Those who contribute a bit if code should
label it with their name. At the beginning of each file the following
template should be filled in

* File: 
* Author: 
* Date: 
* Adjusted: 

* gams-master-file: main.gms

A reading guide provides an overview of the structure
of code. Detailed explanations of each element of the code is given right above or next to the elements themselves. For example, consider the
definition of Equation 1.1 in the file *model_variables_equations.gms* 

    * ## Beginning Block 1: Input-output ##

    * EQUATION 1.1: Product market balance: product output is equal to total uses,
    * including intermediate use, household consumption, government consumption,
    * gross fixed capital formation, stock changes and, in case of an open economy,
    * export. Product market balance is expressed in volume. Product market balance
    * should hold for each product (prd) produced in each region (reg).
    EQBAL(reg,prd)..
        sum((regg,ind), INTER_USE_V(reg,prd,regg,ind) ) +
        sum((regg), CONS_H_V(reg,prd,regg) ) +
        sum((regg), CONS_G_V(reg,prd,regg) ) +
        sum((regg), GFCF_V(reg,prd,regg) ) +
        sum((regg), SV_V(reg,prd,regg) ) +
        EXPORT_ROW_V(reg,prd)
        =E=
        X_V(reg,prd) ;

This way, if the model is updated, comments and documentation should be updated
together with the code. In addition, the length of the documentation
should be kept to a minimum.

## 4., 5., 6. Modular approach
GAMS lacks many nice features of modern general purpose computing
languages. One of them is the support for modules. On the other hand
it has a quite powerful set of compilation controls. The modelling
code in EM-PLUS makes use of these controls to implement a framework for modularity.

Modularity is particularly valuable when we have large models. By developing code using modules we get:
 * A more readable code, divided into thematic parts.
 * A code which can be more easily extended by different coders at the same time (the merge process is much simpler).
 

