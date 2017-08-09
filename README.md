# GitHub Classroom Utils

A set of simple *bash scripts* to automate boring stuff when collecting [GitHub Classroom](https://classroom.github.com/classrooms) assignments.

Scripts require:
- the [jq command-line JSON processor](https://stedolan.github.io/jq/);
- a [personal access token](https://github.com/settings/tokens) from GitHub.

## How do I get set up?

1. clone this repository;
1. create a copy of `config_example` and name it `config`;
1. replace your own configuration settings in the `config` file.

## Availavle tools

### clone.sh

List the clone commands for the given assignment.
Parameters: GitHub `user` and `assignment` name.
  
Example:

```
> ./clone.sh matteocamilli lab01
git clone git@github.com:SELab-unimi/lab01-team_test1.git    99697240
git clone git@github.com:SELab-unimi/lab01-team_test2.git    99697241
...
```

### students.sh

List the students foreach repo of the given assignment.
Parameters: GitHub `user` and `assignment` name.
  
Example:

```
> ./students.sh matteocamilli lab01
99697240, lab01-team_test1, matteocamilli, Matteo Camilli, johndoe, John Doe
99697241, lab01-team_test2, alice, Alice Doe, bob, Bob Doe
...
```
