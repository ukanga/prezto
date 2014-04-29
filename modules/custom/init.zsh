#
# My custom stuff that makes life easy for me.
#
# Authors:
#   Ukang'a Dickson <ukanga@gmail.com>
#

function _workon_cwd()
{
    # adapted from oh-my-zsh virtualenvwrapper

    if [ ! $WORKON_CWD ]; then
        WORKON_CWD=1

        PROJECT_ROOT=`git rev-parse --show-toplevel 2> /dev/null`

        if (( $? != 0 )); then
            PROJECT_ROOT="."
        fi

        if [[ "$PROJECT_ROOT" != "." ]]; then
            ENV_NAME=`basename "$PROJECT_ROOT"`
        else
            ENV_NAME=""
        fi

        if [[ $ENV_NAME != "" ]]; then
            if [[ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]]; then
                if [[ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]]; then
                    workon $ENV_NAME && export CD_VIRTUAL_ENV="$ENV_NAME"
                    which python
                    _local_django_settings_module
                fi
            fi
        elif [ $CD_VIRTUAL_ENV ]; then
            deactivate && unset CD_VIRTUAL_ENV

            if [ $DJANGO_SETTINGS_MODULE ]; then
                unset DJANGO_SETTINGS_MODULE
            fi
        fi

        unset PROJECT_ROOT
        unset WORKON_CWD
    fi
}

function _local_django_settings_module()
{
    if [[ -f "$PROJECT_ROOT/manage.py" ]]; then
        export DJANGO_SETTINGS_MODULE="$ENV_NAME.preset.local_settings"
    fi
}

if (( $+commands[virtualenvwrapper_lazy.sh] )); then
    add-zsh-hook chpwd _workon_cwd
    _workon_cwd
fi
