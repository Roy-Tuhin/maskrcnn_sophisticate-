awk '{print system ("date +%D\" \"%H:%M:%S|tr -d \"'\n'\"")$0}'
