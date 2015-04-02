# General principles of software development 

(copy-pasted for now, change it!)

1. *A module should be open for extension but closed for
   modification*: we should write our modules
so that they can be extended, without requiring them to be modified. In other
words, we want to be able to change what the modules do, without changing the
source code of the modules.

2. *The granule of reuse is the granule of release*: A large
development project is subdivided into a large network of interelated
packages. The work to manage, test, and release those packages is non-trivial. The more
packages that change in any given release, the greater the work to rebuild, test, and
deploy the release. 

3. *Depend in the direction of stability*: Stability is related to the
amount of work required to make a change. One sure way to make a software package
difficult to change, is to make lots of other software packages depend upon it. A
package with lots of incoming dependencies is very stable because it requires a
great deal of work to reconcile any changes with all the dependent packages.

4. *Iterative, incremental and evolutionary development methods*:
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

5. *Code vs. documentation*: documentation should be "Just Barely Good
   Enough" (JBGE) - too much or comprehensive documentation would
   usually cause waste, and developers rarely trust detailed
   documentation because it's usually out of sync with code, while too
   little documentation may also cause problems for maintenance,
   communication, learning and knowledge sharing.

# Implementation in EM-PLUS

## 4. Version management
* GitHub
* Incremental changes

## 5. Documentation and code
* Comments written with code to avoid

## 3. Split between library and project folder
* 

## 1. Modular approach

## 
