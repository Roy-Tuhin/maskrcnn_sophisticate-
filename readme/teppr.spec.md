    python ${prog_teppr} create --type experiment --from ${archcfg} --to ${aids_db_name} --exp train 1>>${prog_log} 2>&1
    python ${prog_teppr} create --type experiment --from ${archcfg} --to ${aids_db_name} --exp evaluate 1>>${prog_log} 2>&1

    python ${prog_falcon} train --dataset ${aids_db_name} --exp ${expid} 1>${prog_log} 2>&1
    python ${prog_falcon} evaluate --dataset ${aids_db_name} --on ${eval_on} --iou ${iou} --exp ${expid_evaluate} 1>${evaluate_prog_log} 2>&1

--exp ${expid},  --exp ${expid_evaluate}  => not needed in integrated workflow as gets generated at run time



- construct archcfg files for tep params

<cmd: c-t-e>
--dataset ${aids_db_name}
--from ${archcfg}
--on ${eval_on} --iou ${iou}

  - create train experiment:
      - using teppry.py -> return the exp_id
  - execute training for the returned exp_id
      - return model_info filename
  - create evaluate experiment
    - before creating exp, replace the model_info filename for the evaluate in the yml file
    - write the arch file back in separate space for debugging purpose if requrie - use and throw
    - return the evaluation exp_id
  - execute evaluation using the returned exp_id
  - create and save the report
    - create report
      - train_<fields>, some items from train cfg from archcfg
      - evaluate_<fields>, some items from evaluate cfg from archcfg; other from processing of evaluate summary `*.ipy` notebook processing
    - save report in db
      - this entry in the same database in new table <some meant only for reporting>
      - save duplicate entry in another database meant for reporting - create new reporting DBCFG
    - save the report also in csv format for excel sheet based reporting (without db dependency)
  - summarize and visualize the report
    - use csv reports and summarize the report
  - upload the csv reports to google docs with public access ->


Key concerns:
1. using single system storage remotely mount for storing logs - file storage
  - running out of capacity
  - Sol:
    - create log directories as system specific directions and use symlinks as generic name
    - mount report systems locally, create consolidated links within generic  name
2. mongodb data is stored in a non-symlink directory and data backups cannot be done smoothly without renaming archive files
3. #1 generates another problem - running out of capacity on all the machines disrupting the workflow
  - Sol:
    - whenever mounting remote systems, inform about remaining storage capacity
    - cutout threshold if less than 20% storage available 