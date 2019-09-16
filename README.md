# Red Optuna

Red Optuna is Ruby bindings for [Optuna](https://optuna.org/), a
hyperparameter optimization framework.

## Description

Red Optuna is a hyperparameter optimization framework. You can
optimize hyperparameter automatically.

## Install

```console
% gem install red-optuna
```

## Usage

Here is an example to optimize hyperparameter for Iris dataset
classifier by Rumale.

```ruby
require "datasets-numo-narray"
require "optuna"
require "rumale"

iris = Datasets::Iris.new.to_table
x = iris.to_narray(:sepal_length,
                   :sepal_width,
                   :petal_length,
                   :petal_width)
y = Numo::NArray[*iris.label_encode(:label)]

study = Optuna::Study.new
study.optimize(n_trials: 100) do |trial|
  classifier_name = trial.suggest_categorical("classifier",
                                              ["SVC", "RandomForest"])
  if classifier_name == "SVC"
    svc_regulation = trial.suggest_uniform("svc_regulation", 0.0, 1.0)
    classifier = Rumale::LinearModel::SVC.new(reg_param: svc_regulation.to_f)
  else
    rf_max_depth = trial.suggest_loguniform("rf_max_depth", 2, 32).to_i
    classifier = Rumale::Ensemble::RandomForestClassifier.new(max_depth: rf_max_depth)
  end

  splitter = Rumale::ModelSelection::StratifiedKFold.new
  cv = Rumale::ModelSelection::CrossValidation.new(estimator: classifier,
                                                   splitter: splitter)
  report = cv.perform(x, y)
  accuracy = report[:test_score].sum / splitter.n_splits
  1.0 - accuracy
end

#puts PyCall.tuple(study.best_trial)
puts study.best_params
```

## License

The MIT license. See `LICENSE.txt` for details.
