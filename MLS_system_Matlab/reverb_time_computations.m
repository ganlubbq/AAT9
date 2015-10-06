TRIM_LENGTH = 20000;
OFFSET_IRS = 25;
VERTICAL_RANGE = [-40 5];

ir_pos1 = audioread('75hz-filtered-pos1-1_best.wav');
ir_pos2 = audioread('75hz-filtered-pos2-2_best.wav');
ir_pos3 = audioread('75hz-filtered-pos3-3_best.wav');

ir_pos1 = ir_pos1 / max(abs(ir_pos1));
ir_pos2 = ir_pos2 / max(abs(ir_pos2));
ir_pos3 = ir_pos3 / max(abs(ir_pos3));


ir_pos1 = ir_pos1(1:TRIM_LENGTH);
ir_pos2 = ir_pos2(1:TRIM_LENGTH);
ir_pos3 = ir_pos3(1:TRIM_LENGTH);

sbi_1 = 10*log10(SBI(ir_pos1) / 20);
sbi_2 = 10*log10(SBI(ir_pos2) / 20);
sbi_3 = 10*log10(SBI(ir_pos3) / 20);


sbi_1 = sbi_1 - max(sbi_1);
sbi_2 = sbi_2 - max(sbi_2);
sbi_3 = sbi_3 - max(sbi_3);

ir_pos1 = ir_pos1 * 20;
ir_pos2 = ir_pos2 * 20;
ir_pos3 = ir_pos3 * 20;

ir_pos1 = ir_pos1 - OFFSET_IRS;
ir_pos2 = ir_pos2 - OFFSET_IRS;
ir_pos3 = ir_pos3 - OFFSET_IRS;



subplot(3,1,1)
plot(ir_pos1, 'b')
hold on
plot(sbi_1, 'k', 'LineWidth', 2)
legend('IR', 'SBI')
xlabel('Position 1')
ylim(VERTICAL_RANGE)
grid

subplot(3,1,2)
plot(ir_pos2, 'b')
hold on
plot(sbi_2, 'k', 'LineWidth', 2)
legend('IR', 'SBI')
xlabel('Position 2')
ylim(VERTICAL_RANGE)
grid

subplot(3,1,3)
plot(ir_pos3, 'b')
hold on
plot(sbi_3, 'k', 'LineWidth', 2)
legend('IR', 'SBI')
xlabel('Position 1')
ylim(VERTICAL_RANGE)
grid

