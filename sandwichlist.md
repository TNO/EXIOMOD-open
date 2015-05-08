# How to get started: a brief description of the architecture

Create a new branch from the master branch on GitHub. The master branch consists of the following core components:

1. A library-folder containing the base-model. Files in the library folder should never be modified.

2. A project_example-folder containing examples of structure and code one could use for a project. Examples of data aggregation are also included in this folder.

3. The file `configuration.gms` which contains project-specific, linked to project_example, settings such as project name, base-year and base-currency. For each project a new project name should be given, corresponding to the name of the project folder (see below).

4. The file `main.gms` which contains simulation-specific settings, such as which simulation file to run. For each project a new *main* file(s) should be specified, each linking to the simulation-specific .gms file (see below).

# How to set up a project folder

A project folder has the following structure:

* *00-principal* (required) contains input files needed to run the base-model. The structure of the sub-folders and file names are predefined and explained in more details below. The names and structure cannot be changed because the files are being called from the library-folder.

* *##-scenario* (optional) contains scenario-specific input files. Presence of this folder(s) is not necessary and is decided according to the needs of the project. In case scenario(s) require input from various external data files (e.g. from other reports and other models) is it recommended to create this structure.

By running [make_project_structure](make_project_structure.bat) one creates a project folder structure with *00-principal* and one *##-scenario*. The user will be prompted to provide a title for his/her project.

### Inside *00-principal* folder

This folder has a well pre-defined structure:

* *sets* contains sets describing the desired level of detail of the model. For each project the user needs to define how many sectors and regions he/she wants to model. [See more](documentation\readme's\readme_principal_sets.txt) on the file naming requirements.

    * *aggregation* contains link between sets with the desired level of detail of the model and sets with the level of detail of the database. [See more](documentation\readme's\readme_principal_sets_aggregation.txt) on the file naming requirements.

* *data* contains user input for the substitution elasticities and starting values of factor productivities. Sectoral and product level of detail in the data file should correspond to the chosen level of detail in the model (as in 00-principal --> sets). The user is required to use the provided template file `Eldata.xlsx`.

* *scr* contains scripts for running simulations, the scripts will be called from `main.gms`. It is recommended to have two types of scripts in this folder:

    * one for preparation of scenario-specific inputs into a format usable by the model. The user would probably need this script only if *##-scenario* folders are also being created.

    * one or multiple for running the actual simulations. The user can wither include all the scenarios into one simulation script, or have a dedicated script per scenario, the choice depends on complexity of the project. It is recommended to follow the structure of provided template file 'run_simulation.gms'.

Examples of specific sets, aggregations, data and script files can be taken from project_example.

### Inside *##-scenario* folder(s)

This folder(s) follows the same structure as *00-principal*. In the sub-folder *data* the user should include the external data files with information on scenario-specific inputs. In the sub-folder *sets* the dimensions of these external data files should be described and the linkages to the dimensions of the model established. In the sub-folder *scr* the script for conversion of the external data files into model inputs are collected; these scripts will then be called from *00-principal/scr*.

# Coding style conventions

These conventions are applied in the base-model and need to be applied to any new code that is being added to the library of the base-model.

* **Code width** is 80 characters, this allows to code to be readable on most screens and also in print.

* **Tab indent** corresponds to 4 spaces.

* **Indentation and alignment** of the code are used to improve readability.

* Use of spaces in the **formulas** is also important for readability, such as in the following examples:
```
sum((reg,prd), SUP(reg,prd,regg,ind) )

= CONS_G_D(prd,regg) + CONS_G_M(prd,regg) ;

= INTER_USE_D(prd,regg,ind) / INTER_USE_T(prd,regg,ind) *
( ( 1 + tc_ind(prd,regg,ind) ) / 1 )**( -elasIU_DM(prd,regg,ind) ) ;
```

* **Declaration** of sets, parameters, variables and equations:
```
Parameters
    elasKL(regg,ind)            substitution elasticity between capital and
                                # labour
...
    GSAV(regg)                  government savings
;
```
    * Indent each new element with one tab.
    * Provide sufficient explanatory text for each element. If the explanatory text doesn't fit within the 80-characters limit, use the end of line comments (#), which are activated in the beginning of a .gms file:
    ```
    $oneolcom
    $eolcom #
    ```
    * Align all the explanatory text on the left.
    * Declaration ends with a closing semicolon on a new line.

* **Assignment** of values to parameters:
```
CONS_H(reg,prd,regg)$( sameas(reg,regg) or TRADE(reg,prd,regg) )
    = ( CONS_H_D(prd,regg) )$sameas(reg,regg) +
    ( CONS_H_M(prd,regg) * TRADE(reg,prd,regg) /
    ( sum(reggg, TRADE(reggg,prd,regg) ) +
    IMPORT_ROW(prd,regg) ) )$(not sameas(reg,regg)) ;
```
    * First line: parameter name and possible $-sign conditionals.
    * Second line: indent with one tab and starts with equality sign (=).
    * Next lines: indent with one tab.

* **Definition** of equations:
```
EQCONS_H_T(prd,regg)..
    CONS_H_T_V(prd,regg)
    =E=
    SCLFD_H_V(regg) * theta_h(prd,regg) *
    ( PC_H_V(prd,regg) * ( 1 + tc_h(prd,regg) ) )**( -elasFU_H(regg) ) ;
```
    * First line: equation name and posible $-sign conditionals.
    * Next lines: indent with one tab.
    * =E=, =L=, =G= are placed on a separate line for visibility.

* **Model statement** is spread over multiple lines, where one line is given to each separate element:
```
Model IO_industry_technology
/
EQBAL
EQY
...
EQOBJ
/
;
```

* **Display statement** is spread over multiple lines, where one line is given to each separate element:
```
Display
INTER_USE_T
INTER_USE
;
```


# How to make your own modifications

(not completed)

1. Become acquainted with the structure of the thematic modules (which equations
   and variables belong to which module?). An overview of the modules can be
   found [here](http://htmlpreview.github.io/?https://raw.githubusercontent.com/em-plus/TNO-Eco-Mod/mastah_trond/modules.html?token=AHa1f0Ls09mStpGbCLxLWEdS3SvWSG_7ks5VVh0XwA%3D%3D)

2. If aggregating or extending sets, or adding data, become acquainted with the set
   structure: find out whether the modified set is a subset. Sets are
   listed in the .txt-files in the */library/sets* folder.

3. If new data needs to be added, data files must be placed in the
   *data* folder and read in data using the *user_data.gms*. If
   elasticities or technology-parameters need to be changed, the
   excel-sheets already in the folder can be used.

4. Open the relevant modules in */library/scr/*. Search
   for: (i) equations that need to be changed; (ii) variables that
   need to be changed; (iii) parameters that need to be changed.

6. Making changes to equations: equations which need to be changed need to be
   renamed, e.g. from EQKL to EQKL_pr, and restated. Make sure to
   include scaling of the equations after the model statement.

7. Making changes to variables: equations which need to be changed need to be
   renamed, e.g. from KL to EQKL_pr. Make sure to include
   bounds/starting values/fixed values of variables after the model
   statement.

8. Making changes to the model: a new model needs to be defined with
   new variables/equations. The new model must state: (i) the original
   model; (ii) the equations from the original model that needs to be
   dropped (with a minus (-) sign in front); (iii) additional
   equations and variables in the new model.

9. Make sure that (i) the project name in *configuration.gms*
   corresponds to the name of the project folder; (ii) the name of the
   simulation file in *main.gms* corresponds to the name of the
   simulation-specific .gms-file.


