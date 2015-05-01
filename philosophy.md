# General principles of software development 

We have compiled the following list from various sources on software development (e.g. object-oriented, agile). We are not strictly following one of the existing approaches, but rather finding a suitable mix of principles that will support long-term development of Economic Modelling Platform for Sustainability (EM-PLUS).

1. *Iterative, incremental and evolutionary development methods*: tasks are broken into small increments, iterations, with minimal planning and do not directly involve long-term planning. This allows the project to adapt quickly to changing environment. An iteration might not add enough functionality to warrant a market release, but the goal is to have an available release (with minimal bugs) at the end of each iteration.

2. *Code vs. documentation*: documentation should be "Just Barely Good Enough" (JBGE) - too much or comprehensive documentation would usually cause waste. Developers rarely trust detailed documentation because it's usually out of sync with code. At the same time too little documentation may also cause problems for maintenance, communication, learning and knowledge sharing.

3. *A module should be open for extension but closed for modification*: we should write our modules so that they can be extended, without requiring them to be modified. In other words, we want to be able to change what the modules do, without changing the source code of the modules.

4. *Classes that change together, belong together*: A large development project is subdivided into a large network of interrelated packages. The work to manage, test, and release those packages is non-trivial. The more packages that change in any given release, the greater the work to rebuild, test, and deploy the release. 

5. *Depend in the direction of stability*: Stability is related to the amount of work required to make a change. One sure way to make a software package  difficult to change, is to make lots of other software packages depend upon it.A package with lots of incoming dependencies is very stable because it requires a great deal of work to reconcile any changes with all the dependent packages. A piece of software that is designed to be stable should not depend on the piece that is designed to be flexible (not stable).

# How the principles are implemented in EM-PLUS

### Split between library and project folder (Principles 3., 4., 5.)
The development of EM-PLUS is based on a split between the code from the *library* and the code developed under each *project*. These two are kept in separate folders. The model in the library is a self-contained model and will be referred to as the *Base Model*. At the beginning of each project, the project team will start with a basic working CGE model, which is used in combination with code created specifically for the project. See the file *sandwichlist.md* for instructions on how to start up your project and how to implement own modifications. Code developed in the project can potentially be merged back into library after the project has been finished.

###  Version management (Principle 1.)
Modifications in EM-PLUS should be *incremental* and *well-documented*, facilitating collaborative code development, making it easy to synchronize to the common established code base and to document changes in the code from version to version. The main tool for ensuring proper version management is GitHub. GitHub is a web-based Git repository hosting service, which offers all of the distributed revision control and source code management (SCM) functionality of Git as well as adding its own features. A one page guide to getting started with GitHub can be found at http://rogerdudler.github.io/git-guide/.

In order to make sure changes are incremental, we would like developers to accompany commits with a clear description of what was changed and why. Avoid committing whole bundles of unrelated changes with one commit. As a rule of
thumb, commits should not contain more than three major changes.

### Documentation and code (Principle 2.)
Besides formal documentation of the structure (equations), EM-PLUS mainly relies on documentation within the code itself. Those who contribute a bit of code should label it with their name. At the beginning of each file the following template should be filled in
```
* File: 
* Author: 
* Date: 
* Adjusted: 

* gams-master-file:
```

A block of reading guide in the beginning of the code provides an overview of the structure of code, reference to other similar codes and other general information about the code. Detailed explanations of each element of the code are given right above or next to the elements themselves. For example, consider the definition of an equation in the file `06_module_production.gms` 

```
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
```

This way, if the model is updated, comments and documentation should be updated
together with the code. In addition, the length of the documentation should be kept to a minimum.

### Modular approach (Principles 3., 4., 5.)
Here modularity means that a large model code is split into rather compact thematic blocks of code, such as producer, consumer, trade, etc. Each module code contains both the calibration and equation parts of the block. We define the content of each module and the connection channels between the modules. The modules and their interconnections should be structured in such a way that replacing one of the modules, for example consumer LES demand function instead of Cobb-Douglas, doesn't require to make changes in other modules. Working with modules also simplifies the development process if several people change code at the same time.
In GAMS the order in which a code is compiled is important. For example, if a *parameter* is used in an equation, it should be declared and assigned before the definition statement for the equation. On the other hand GAMS has a quite powerful set of compilation controls. The *Base model* in EM-PLUS makes use of these controls to implement a framework for modularity. Please see the [document by Marco Loparic](https://docs.google.com/document/d/1__9okBI8LsNnzDw_z4x80vfgUb5GUv3vKV_kptxXIbY/edit) for details on the approach.
