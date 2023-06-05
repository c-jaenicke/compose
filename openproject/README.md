# compose - openproject

The current compose file is the "All-in-one container".

See <https://www.openproject.org/docs/installation-and-operations/installation/docker/> for more information about
deploying OpenProject.

## Important Note

For some reason this container breaks after running for approximately 24 hours!
To combat this, the container should be restarted after 24 hours.

Restarting the container is the easiest fix for this problem.
Using a docker healthcheck didn't work for me.
