# Debugging

1. New setup issues
  * a) mongodb docker conatiner
    - check if mongodb is already installed in host system, either map to different port or ask user which mongodb installation is to be used.
    - currently, in such case docker container gives error stating port already in use:
      ```
      docker: Error response from daemon: driver failed programming external connectivity on endpoint aimldl-mongouid (efccc63be4b576031ab19c910e17e8c1f602e8e9d6358ef0318fa11c20710790): Error starting userland proxy: listen tcp 0.0.0.0:27017: bind: address already in use
      ```
    - work-around fix, stop the mongodb host service
    - check if port is free or used: `netstat -l | grep 27017`
2. Starting AI API port
  - docker service should be up and running, no errors gets printed if service is not up
3. **Installation errors debugging tips**
  * Manual checks and changes to be done
    1. Change the ip in `index.py` i.e., `$AI_HOME/apps/www/od/wsgi-bin/web_server.py`: `app.run(debug=True, host='10.4.71.59')`