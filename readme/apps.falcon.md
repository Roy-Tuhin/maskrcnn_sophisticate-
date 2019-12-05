
TODO

## Per

## Rough Notes

**Testing MongoDB Training workflow**
```bash
python falcon.py train --dataset PXL-260619_221820_050719_145559 --exp uuid-1a96f078-fc53-4ea6-85dc-008719bfbdfa --tdd
#
python falcon.py train --dataset PXL-240719_215430_250719_103904 --exp uuid-0d9ebd18-3230-4bd1-94b6-91c182508627 1>${AI_LOGS}/falcon-$(date -d now +'%d%m%y_%H%M%S').log 2>&1
```