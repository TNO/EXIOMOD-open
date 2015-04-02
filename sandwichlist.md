# How to get started: a brief description of the architecture 

Get the template model from GitHub. This model consists of the
following components:

1. A library-folder containing the base-model. Files in the library
folder should not be modified.

2. The file *config.gms* which contains project-specific settings such as
project name, base-year and base-currency. For each project a new project
name should be given, corresponding to the name of the project folder
(see below).

3. The file *main.gms* which contains simulation-specific
settings such as which simulation file to run. For each project a new
simulation file should be specified, corresponding to the
simulation-specific .gms file (see below).

4. A *project* folder which should be given a project-specific
   name. It contains the following sub-folders:

4.1 *sets*: contains separate .txt-files for the sets used in the model(region, sector, final demand
category etc.). The subfolder *aggregation* contains .txt files which
determine the aggregation from the database to the model.

4.2 *data*: contains excel sheets or .gdx files for model-specific
data. The folder contains two excel sheets with default values for
elasticities and technology parameters in the production function.

4.3 *simulation*:  contains the files *user_data.gms* and a template
.gms -file which should be given a simulation-specific name.

# How to make your own modifications

1. Open the simulation-specific .gms-file. Changes are incoporated
   here, leaving files in the library unchanged. 

2. If aggregating or extending sets, or adding data, become acquainted with the set
   structure: find out whether the modified set is a subset. Sets are
   listed in the .txt-files in the *sets* folder.

3. If new data needs to be added, data files must be placed in the
   *data* folder and read in data using the *user_data.gms*. If
   elasticities or technology-parameters need to be changed, the
   excel-sheets already in the folder can be used.

4. Open the file */library/scr/model_variables_equations.gms*. Search
   for: (i) equations that need to be changed; (ii) variables that
   need to be changed; (iii) parameters that need to be changed.

5. Making changes to parameters: if parameters need to be recalibrated, consult
   the file */library/scr/model_parameters.gms* to see how they were
   calibrated in the base-model.

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
   
   
