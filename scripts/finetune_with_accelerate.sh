# export CUDA_VISIBLE_DEVICES=0,1,2,3

# MODEL_SIZE=7B
# NUM_GPUS=4
# BATCH_SIZE_PER_GPU=2
# TOTAL_BATCH_SIZE=128
# GRADIENT_ACC_STEPS=$(($TOTAL_BATCH_SIZE/$NUM_GPUS/$BATCH_SIZE_PER_GPU))
# echo "Training llama model ${MODEL_SIZE} using $NUM_GPUS GPUs, $BATCH_SIZE_PER_GPU batch size per GPU, $GRADIENT_ACC_STEPS gradient accumulation steps"

# accelerate launch \
#     --mixed_precision bf16 \
#     --num_machines 1 \
#     --num_processes $NUM_GPUS \
#     --use_deepspeed \
#     --deepspeed_config_file ds_configs/stage3_no_offloading_accelerate.conf \
#     open_instruct/finetune.py \
#     --model_name_or_path ../hf_llama_models/${MODEL_SIZE} \
#     --use_flash_attn \
#     --tokenizer_name ../hf_llama_models/${MODEL_SIZE} \
#     --use_slow_tokenizer \
#     --train_file data/processed/tulu_v1/tulu_v1_data.jsonl \
#     --max_seq_length 2048 \
#     --preprocessing_num_workers 16 \
#     --per_device_train_batch_size $BATCH_SIZE_PER_GPU \
#     --gradient_accumulation_steps $GRADIENT_ACC_STEPS \
#     --learning_rate 2e-5 \
#     --lr_scheduler_type linear \
#     --warmup_ratio 0.03 \
#     --weight_decay 0. \
#     --num_train_epochs 2 \
#     --output_dir output/tulu_v1_${MODEL_SIZE}/ \
#     --with_tracking \
#     --report_to tensorboard \
#     --logging_steps 1


MODEL_SIZE=2b
BATCH_SIZE_PER_GPU=4
GRADIENT_ACC_STEPS=4
echo "Training gemma model ${MODEL_SIZE} using $NUM_GPUS GPUs, $BATCH_SIZE_PER_GPU batch size per GPU, $GRADIENT_ACC_STEPS gradient accumulation steps"


PYTORCH_ENABLE_MPS_FALLBACK=1 
PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0 accelerate launch \
    open_instruct/finetune.py \
    --model_name_or_path google/gemma-${MODEL_SIZE} \
    --tokenizer_name google/gemma-${MODEL_SIZE} \
    --train_file data/processed/dolly/dolly_data.jsonl \
    --max_seq_length 2048 \
    --preprocessing_num_workers 16 \
    --per_device_train_batch_size $BATCH_SIZE_PER_GPU \
    --gradient_accumulation_steps $GRADIENT_ACC_STEPS \
    --learning_rate 2e-5 \
    --lr_scheduler_type linear \
    --warmup_ratio 0.03 \
    --weight_decay 0. \
    --num_train_epochs 2 \
    --output_dir output/dolly_${MODEL_SIZE}/ \
    --with_tracking \
    --report_to tensorboard \
    --logging_steps 1