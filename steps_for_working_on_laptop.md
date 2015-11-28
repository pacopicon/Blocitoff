Steps for switching work between computers:

I - Switching from Computer 1 to Computer 2 (This website has all the instructions to do it on Command line: https://help.github.com/articles/cloning-a-repository/)

    1 - (You can also) Go to the repository page on GitHub and click on “Clone in Desktop”, which will open the GitHub Desktop Mac application on Computer 2.  Clone by clicking with mouse.  Open the file.

    2 - Make sure all Gemfiles are up-to-date: On Terminal: bundle

    3 - Make sure all migrations are up-to-date: Rake db:migrate

    4 - Make sure that config/application.yml file is reproduced ENTIRELY on Computer 2 (since the file is ```.gitignore```ed). Render config/application.yml in Computer 1 into a text message, e-mail, take a picture of it etc.. and send it to Computer 2.

II - Switching back from Computer 2 to Computer 1
    1 - When switching to Computer 1, on Terminal: git reset --hard origin/master
    2 - then, on Terminal: git pull (This is only for small repos!!!) (I also did "git init" prior to this step, so that may help as well)
    3 - Make sure all Gemfiles are up-to-date: On Terminal: bundle

    4 - Make sure all migrations are up-to-date: Rake db:migrate

    5 - Make sure that config/application.yml file is reproduced ENTIRELY on Computer 2 (since the file is ```.gitignore```ed). Render config/application.yml in Computer 1 into a text message, e-mail, take a picture of it etc.. and send it to Computer 2.
