#include <kernel/utils/macros.s>

.code64
.text

.globl isr_cpu_entry_paths_begin
.align 8
isr_cpu_entry_paths_begin:

.align 8
isr_cpu_entry_0:
    movl $0, %eax
    jmp isr_main

.align 8
isr_cpu_entry_1:
    movl $1, %eax
    jmp isr_main

.align 8
isr_cpu_entry_2:
    movl $2, %eax
    jmp isr_main

.align 8
isr_cpu_entry_3:
    movl $3, %eax
    jmp isr_main

.align 8
isr_cpu_entry_4:
    movl $4, %eax
    jmp isr_main

.align 8
isr_cpu_entry_5:
    movl $5, %eax
    jmp isr_main

.align 8
isr_cpu_entry_6:
    movl $6, %eax
    jmp isr_main

.align 8
isr_cpu_entry_7:
    movl $7, %eax
    jmp isr_main

.align 8
isr_cpu_entry_8:
    movl $8, %eax
    jmp isr_main

.align 8
isr_cpu_entry_9:
    movl $9, %eax
    jmp isr_main

.align 8
isr_cpu_entry_10:
    movl $10, %eax
    jmp isr_main

.align 8
isr_cpu_entry_11:
    movl $11, %eax
    jmp isr_main

.align 8
isr_cpu_entry_12:
    movl $12, %eax
    jmp isr_main

.align 8
isr_cpu_entry_13:
    movl $13, %eax
    jmp isr_main

.align 8
isr_cpu_entry_14:
    movl $14, %eax
    jmp isr_main

.align 8
isr_cpu_entry_15:
    movl $15, %eax
    jmp isr_main

.align 8
isr_cpu_entry_16:
    movl $16, %eax
    jmp isr_main

.align 8
isr_cpu_entry_17:
    movl $17, %eax
    jmp isr_main

.align 8
isr_cpu_entry_18:
    movl $18, %eax
    jmp isr_main

.align 8
isr_cpu_entry_19:
    movl $19, %eax
    jmp isr_main

.align 8
isr_cpu_entry_20:
    movl $20, %eax
    jmp isr_main

.align 8
isr_cpu_entry_21:
    movl $21, %eax
    jmp isr_main

.align 8
isr_cpu_entry_22:
    movl $22, %eax
    jmp isr_main

.align 8
isr_cpu_entry_23:
    movl $23, %eax
    jmp isr_main

.align 8
isr_cpu_entry_24:
    movl $24, %eax
    jmp isr_main

.align 8
isr_cpu_entry_25:
    movl $25, %eax
    jmp isr_main

.align 8
isr_cpu_entry_26:
    movl $26, %eax
    jmp isr_main

.align 8
isr_cpu_entry_27:
    movl $27, %eax
    jmp isr_main

.align 8
isr_cpu_entry_28:
    movl $28, %eax
    jmp isr_main

.align 8
isr_cpu_entry_29:
    movl $29, %eax
    jmp isr_main

.align 8
isr_cpu_entry_30:
    movl $30, %eax
    jmp isr_main

.align 8
isr_cpu_entry_31:
    movl $31, %eax
    jmp isr_main

.align 8
isr_cpu_entry_32:
    movl $32, %eax
    jmp isr_main

.align 8
isr_cpu_entry_33:
    movl $33, %eax
    jmp isr_main

.align 8
isr_cpu_entry_34:
    movl $34, %eax
    jmp isr_main

.align 8
isr_cpu_entry_35:
    movl $35, %eax
    jmp isr_main

.align 8
isr_cpu_entry_36:
    movl $36, %eax
    jmp isr_main

.align 8
isr_cpu_entry_37:
    movl $37, %eax
    jmp isr_main

.align 8
isr_cpu_entry_38:
    movl $38, %eax
    jmp isr_main

.align 8
isr_cpu_entry_39:
    movl $39, %eax
    jmp isr_main

.align 8
isr_cpu_entry_40:
    movl $40, %eax
    jmp isr_main

.align 8
isr_cpu_entry_41:
    movl $41, %eax
    jmp isr_main

.align 8
isr_cpu_entry_42:
    movl $42, %eax
    jmp isr_main

.align 8
isr_cpu_entry_43:
    movl $43, %eax
    jmp isr_main

.align 8
isr_cpu_entry_44:
    movl $44, %eax
    jmp isr_main

.align 8
isr_cpu_entry_45:
    movl $45, %eax
    jmp isr_main

.align 8
isr_cpu_entry_46:
    movl $46, %eax
    jmp isr_main

.align 8
isr_cpu_entry_47:
    movl $47, %eax
    jmp isr_main

.align 8
isr_cpu_entry_48:
    movl $48, %eax
    jmp isr_main

.align 8
isr_cpu_entry_49:
    movl $49, %eax
    jmp isr_main

.align 8
isr_cpu_entry_50:
    movl $50, %eax
    jmp isr_main

.align 8
isr_cpu_entry_51:
    movl $51, %eax
    jmp isr_main

.align 8
isr_cpu_entry_52:
    movl $52, %eax
    jmp isr_main

.align 8
isr_cpu_entry_53:
    movl $53, %eax
    jmp isr_main

.align 8
isr_cpu_entry_54:
    movl $54, %eax
    jmp isr_main

.align 8
isr_cpu_entry_55:
    movl $55, %eax
    jmp isr_main

.align 8
isr_cpu_entry_56:
    movl $56, %eax
    jmp isr_main

.align 8
isr_cpu_entry_57:
    movl $57, %eax
    jmp isr_main

.align 8
isr_cpu_entry_58:
    movl $58, %eax
    jmp isr_main

.align 8
isr_cpu_entry_59:
    movl $59, %eax
    jmp isr_main

.align 8
isr_cpu_entry_60:
    movl $60, %eax
    jmp isr_main

.align 8
isr_cpu_entry_61:
    movl $61, %eax
    jmp isr_main

.align 8
isr_cpu_entry_62:
    movl $62, %eax
    jmp isr_main

.align 8
isr_cpu_entry_63:
    movl $63, %eax
    jmp isr_main

.align 8
isr_cpu_entry_64:
    movl $64, %eax
    jmp isr_main

.align 8
isr_cpu_entry_65:
    movl $65, %eax
    jmp isr_main

.align 8
isr_cpu_entry_66:
    movl $66, %eax
    jmp isr_main

.align 8
isr_cpu_entry_67:
    movl $67, %eax
    jmp isr_main

.align 8
isr_cpu_entry_68:
    movl $68, %eax
    jmp isr_main

.align 8
isr_cpu_entry_69:
    movl $69, %eax
    jmp isr_main

.align 8
isr_cpu_entry_70:
    movl $70, %eax
    jmp isr_main

.align 8
isr_cpu_entry_71:
    movl $71, %eax
    jmp isr_main

.align 8
isr_cpu_entry_72:
    movl $72, %eax
    jmp isr_main

.align 8
isr_cpu_entry_73:
    movl $73, %eax
    jmp isr_main

.align 8
isr_cpu_entry_74:
    movl $74, %eax
    jmp isr_main

.align 8
isr_cpu_entry_75:
    movl $75, %eax
    jmp isr_main

.align 8
isr_cpu_entry_76:
    movl $76, %eax
    jmp isr_main

.align 8
isr_cpu_entry_77:
    movl $77, %eax
    jmp isr_main

.align 8
isr_cpu_entry_78:
    movl $78, %eax
    jmp isr_main

.align 8
isr_cpu_entry_79:
    movl $79, %eax
    jmp isr_main

.align 8
isr_cpu_entry_80:
    movl $80, %eax
    jmp isr_main

.align 8
isr_cpu_entry_81:
    movl $81, %eax
    jmp isr_main

.align 8
isr_cpu_entry_82:
    movl $82, %eax
    jmp isr_main

.align 8
isr_cpu_entry_83:
    movl $83, %eax
    jmp isr_main

.align 8
isr_cpu_entry_84:
    movl $84, %eax
    jmp isr_main

.align 8
isr_cpu_entry_85:
    movl $85, %eax
    jmp isr_main

.align 8
isr_cpu_entry_86:
    movl $86, %eax
    jmp isr_main

.align 8
isr_cpu_entry_87:
    movl $87, %eax
    jmp isr_main

.align 8
isr_cpu_entry_88:
    movl $88, %eax
    jmp isr_main

.align 8
isr_cpu_entry_89:
    movl $89, %eax
    jmp isr_main

.align 8
isr_cpu_entry_90:
    movl $90, %eax
    jmp isr_main

.align 8
isr_cpu_entry_91:
    movl $91, %eax
    jmp isr_main

.align 8
isr_cpu_entry_92:
    movl $92, %eax
    jmp isr_main

.align 8
isr_cpu_entry_93:
    movl $93, %eax
    jmp isr_main

.align 8
isr_cpu_entry_94:
    movl $94, %eax
    jmp isr_main

.align 8
isr_cpu_entry_95:
    movl $95, %eax
    jmp isr_main

.align 8
isr_cpu_entry_96:
    movl $96, %eax
    jmp isr_main

.align 8
isr_cpu_entry_97:
    movl $97, %eax
    jmp isr_main

.align 8
isr_cpu_entry_98:
    movl $98, %eax
    jmp isr_main

.align 8
isr_cpu_entry_99:
    movl $99, %eax
    jmp isr_main

.align 8
isr_cpu_entry_100:
    movl $100, %eax
    jmp isr_main

.align 8
isr_cpu_entry_101:
    movl $101, %eax
    jmp isr_main

.align 8
isr_cpu_entry_102:
    movl $102, %eax
    jmp isr_main

.align 8
isr_cpu_entry_103:
    movl $103, %eax
    jmp isr_main

.align 8
isr_cpu_entry_104:
    movl $104, %eax
    jmp isr_main

.align 8
isr_cpu_entry_105:
    movl $105, %eax
    jmp isr_main

.align 8
isr_cpu_entry_106:
    movl $106, %eax
    jmp isr_main

.align 8
isr_cpu_entry_107:
    movl $107, %eax
    jmp isr_main

.align 8
isr_cpu_entry_108:
    movl $108, %eax
    jmp isr_main

.align 8
isr_cpu_entry_109:
    movl $109, %eax
    jmp isr_main

.align 8
isr_cpu_entry_110:
    movl $110, %eax
    jmp isr_main

.align 8
isr_cpu_entry_111:
    movl $111, %eax
    jmp isr_main

.align 8
isr_cpu_entry_112:
    movl $112, %eax
    jmp isr_main

.align 8
isr_cpu_entry_113:
    movl $113, %eax
    jmp isr_main

.align 8
isr_cpu_entry_114:
    movl $114, %eax
    jmp isr_main

.align 8
isr_cpu_entry_115:
    movl $115, %eax
    jmp isr_main

.align 8
isr_cpu_entry_116:
    movl $116, %eax
    jmp isr_main

.align 8
isr_cpu_entry_117:
    movl $117, %eax
    jmp isr_main

.align 8
isr_cpu_entry_118:
    movl $118, %eax
    jmp isr_main

.align 8
isr_cpu_entry_119:
    movl $119, %eax
    jmp isr_main

.align 8
isr_cpu_entry_120:
    movl $120, %eax
    jmp isr_main

.align 8
isr_cpu_entry_121:
    movl $121, %eax
    jmp isr_main

.align 8
isr_cpu_entry_122:
    movl $122, %eax
    jmp isr_main

.align 8
isr_cpu_entry_123:
    movl $123, %eax
    jmp isr_main

.align 8
isr_cpu_entry_124:
    movl $124, %eax
    jmp isr_main

.align 8
isr_cpu_entry_125:
    movl $125, %eax
    jmp isr_main

.align 8
isr_cpu_entry_126:
    movl $126, %eax
    jmp isr_main

.align 8
isr_cpu_entry_127:
    movl $127, %eax
    jmp isr_main

.align 8
isr_cpu_entry_128:
    movl $128, %eax
    jmp isr_main

.align 8
isr_cpu_entry_129:
    movl $129, %eax
    jmp isr_main

.align 8
isr_cpu_entry_130:
    movl $130, %eax
    jmp isr_main

.align 8
isr_cpu_entry_131:
    movl $131, %eax
    jmp isr_main

.align 8
isr_cpu_entry_132:
    movl $132, %eax
    jmp isr_main

.align 8
isr_cpu_entry_133:
    movl $133, %eax
    jmp isr_main

.align 8
isr_cpu_entry_134:
    movl $134, %eax
    jmp isr_main

.align 8
isr_cpu_entry_135:
    movl $135, %eax
    jmp isr_main

.align 8
isr_cpu_entry_136:
    movl $136, %eax
    jmp isr_main

.align 8
isr_cpu_entry_137:
    movl $137, %eax
    jmp isr_main

.align 8
isr_cpu_entry_138:
    movl $138, %eax
    jmp isr_main

.align 8
isr_cpu_entry_139:
    movl $139, %eax
    jmp isr_main

.align 8
isr_cpu_entry_140:
    movl $140, %eax
    jmp isr_main

.align 8
isr_cpu_entry_141:
    movl $141, %eax
    jmp isr_main

.align 8
isr_cpu_entry_142:
    movl $142, %eax
    jmp isr_main

.align 8
isr_cpu_entry_143:
    movl $143, %eax
    jmp isr_main

.align 8
isr_cpu_entry_144:
    movl $144, %eax
    jmp isr_main

.align 8
isr_cpu_entry_145:
    movl $145, %eax
    jmp isr_main

.align 8
isr_cpu_entry_146:
    movl $146, %eax
    jmp isr_main

.align 8
isr_cpu_entry_147:
    movl $147, %eax
    jmp isr_main

.align 8
isr_cpu_entry_148:
    movl $148, %eax
    jmp isr_main

.align 8
isr_cpu_entry_149:
    movl $149, %eax
    jmp isr_main

.align 8
isr_cpu_entry_150:
    movl $150, %eax
    jmp isr_main

.align 8
isr_cpu_entry_151:
    movl $151, %eax
    jmp isr_main

.align 8
isr_cpu_entry_152:
    movl $152, %eax
    jmp isr_main

.align 8
isr_cpu_entry_153:
    movl $153, %eax
    jmp isr_main

.align 8
isr_cpu_entry_154:
    movl $154, %eax
    jmp isr_main

.align 8
isr_cpu_entry_155:
    movl $155, %eax
    jmp isr_main

.align 8
isr_cpu_entry_156:
    movl $156, %eax
    jmp isr_main

.align 8
isr_cpu_entry_157:
    movl $157, %eax
    jmp isr_main

.align 8
isr_cpu_entry_158:
    movl $158, %eax
    jmp isr_main

.align 8
isr_cpu_entry_159:
    movl $159, %eax
    jmp isr_main

.align 8
isr_cpu_entry_160:
    movl $160, %eax
    jmp isr_main

.align 8
isr_cpu_entry_161:
    movl $161, %eax
    jmp isr_main

.align 8
isr_cpu_entry_162:
    movl $162, %eax
    jmp isr_main

.align 8
isr_cpu_entry_163:
    movl $163, %eax
    jmp isr_main

.align 8
isr_cpu_entry_164:
    movl $164, %eax
    jmp isr_main

.align 8
isr_cpu_entry_165:
    movl $165, %eax
    jmp isr_main

.align 8
isr_cpu_entry_166:
    movl $166, %eax
    jmp isr_main

.align 8
isr_cpu_entry_167:
    movl $167, %eax
    jmp isr_main

.align 8
isr_cpu_entry_168:
    movl $168, %eax
    jmp isr_main

.align 8
isr_cpu_entry_169:
    movl $169, %eax
    jmp isr_main

.align 8
isr_cpu_entry_170:
    movl $170, %eax
    jmp isr_main

.align 8
isr_cpu_entry_171:
    movl $171, %eax
    jmp isr_main

.align 8
isr_cpu_entry_172:
    movl $172, %eax
    jmp isr_main

.align 8
isr_cpu_entry_173:
    movl $173, %eax
    jmp isr_main

.align 8
isr_cpu_entry_174:
    movl $174, %eax
    jmp isr_main

.align 8
isr_cpu_entry_175:
    movl $175, %eax
    jmp isr_main

.align 8
isr_cpu_entry_176:
    movl $176, %eax
    jmp isr_main

.align 8
isr_cpu_entry_177:
    movl $177, %eax
    jmp isr_main

.align 8
isr_cpu_entry_178:
    movl $178, %eax
    jmp isr_main

.align 8
isr_cpu_entry_179:
    movl $179, %eax
    jmp isr_main

.align 8
isr_cpu_entry_180:
    movl $180, %eax
    jmp isr_main

.align 8
isr_cpu_entry_181:
    movl $181, %eax
    jmp isr_main

.align 8
isr_cpu_entry_182:
    movl $182, %eax
    jmp isr_main

.align 8
isr_cpu_entry_183:
    movl $183, %eax
    jmp isr_main

.align 8
isr_cpu_entry_184:
    movl $184, %eax
    jmp isr_main

.align 8
isr_cpu_entry_185:
    movl $185, %eax
    jmp isr_main

.align 8
isr_cpu_entry_186:
    movl $186, %eax
    jmp isr_main

.align 8
isr_cpu_entry_187:
    movl $187, %eax
    jmp isr_main

.align 8
isr_cpu_entry_188:
    movl $188, %eax
    jmp isr_main

.align 8
isr_cpu_entry_189:
    movl $189, %eax
    jmp isr_main

.align 8
isr_cpu_entry_190:
    movl $190, %eax
    jmp isr_main

.align 8
isr_cpu_entry_191:
    movl $191, %eax
    jmp isr_main

.align 8
isr_cpu_entry_192:
    movl $192, %eax
    jmp isr_main

.align 8
isr_cpu_entry_193:
    movl $193, %eax
    jmp isr_main

.align 8
isr_cpu_entry_194:
    movl $194, %eax
    jmp isr_main

.align 8
isr_cpu_entry_195:
    movl $195, %eax
    jmp isr_main

.align 8
isr_cpu_entry_196:
    movl $196, %eax
    jmp isr_main

.align 8
isr_cpu_entry_197:
    movl $197, %eax
    jmp isr_main

.align 8
isr_cpu_entry_198:
    movl $198, %eax
    jmp isr_main

.align 8
isr_cpu_entry_199:
    movl $199, %eax
    jmp isr_main

.align 8
isr_cpu_entry_200:
    movl $200, %eax
    jmp isr_main

.align 8
isr_cpu_entry_201:
    movl $201, %eax
    jmp isr_main

.align 8
isr_cpu_entry_202:
    movl $202, %eax
    jmp isr_main

.align 8
isr_cpu_entry_203:
    movl $203, %eax
    jmp isr_main

.align 8
isr_cpu_entry_204:
    movl $204, %eax
    jmp isr_main

.align 8
isr_cpu_entry_205:
    movl $205, %eax
    jmp isr_main

.align 8
isr_cpu_entry_206:
    movl $206, %eax
    jmp isr_main

.align 8
isr_cpu_entry_207:
    movl $207, %eax
    jmp isr_main

.align 8
isr_cpu_entry_208:
    movl $208, %eax
    jmp isr_main

.align 8
isr_cpu_entry_209:
    movl $209, %eax
    jmp isr_main

.align 8
isr_cpu_entry_210:
    movl $210, %eax
    jmp isr_main

.align 8
isr_cpu_entry_211:
    movl $211, %eax
    jmp isr_main

.align 8
isr_cpu_entry_212:
    movl $212, %eax
    jmp isr_main

.align 8
isr_cpu_entry_213:
    movl $213, %eax
    jmp isr_main

.align 8
isr_cpu_entry_214:
    movl $214, %eax
    jmp isr_main

.align 8
isr_cpu_entry_215:
    movl $215, %eax
    jmp isr_main

.align 8
isr_cpu_entry_216:
    movl $216, %eax
    jmp isr_main

.align 8
isr_cpu_entry_217:
    movl $217, %eax
    jmp isr_main

.align 8
isr_cpu_entry_218:
    movl $218, %eax
    jmp isr_main

.align 8
isr_cpu_entry_219:
    movl $219, %eax
    jmp isr_main

.align 8
isr_cpu_entry_220:
    movl $220, %eax
    jmp isr_main

.align 8
isr_cpu_entry_221:
    movl $221, %eax
    jmp isr_main

.align 8
isr_cpu_entry_222:
    movl $222, %eax
    jmp isr_main

.align 8
isr_cpu_entry_223:
    movl $223, %eax
    jmp isr_main

.align 8
isr_cpu_entry_224:
    movl $224, %eax
    jmp isr_main

.align 8
isr_cpu_entry_225:
    movl $225, %eax
    jmp isr_main

.align 8
isr_cpu_entry_226:
    movl $226, %eax
    jmp isr_main

.align 8
isr_cpu_entry_227:
    movl $227, %eax
    jmp isr_main

.align 8
isr_cpu_entry_228:
    movl $228, %eax
    jmp isr_main

.align 8
isr_cpu_entry_229:
    movl $229, %eax
    jmp isr_main

.align 8
isr_cpu_entry_230:
    movl $230, %eax
    jmp isr_main

.align 8
isr_cpu_entry_231:
    movl $231, %eax
    jmp isr_main

.align 8
isr_cpu_entry_232:
    movl $232, %eax
    jmp isr_main

.align 8
isr_cpu_entry_233:
    movl $233, %eax
    jmp isr_main

.align 8
isr_cpu_entry_234:
    movl $234, %eax
    jmp isr_main

.align 8
isr_cpu_entry_235:
    movl $235, %eax
    jmp isr_main

.align 8
isr_cpu_entry_236:
    movl $236, %eax
    jmp isr_main

.align 8
isr_cpu_entry_237:
    movl $237, %eax
    jmp isr_main

.align 8
isr_cpu_entry_238:
    movl $238, %eax
    jmp isr_main

.align 8
isr_cpu_entry_239:
    movl $239, %eax
    jmp isr_main

.align 8
isr_cpu_entry_240:
    movl $240, %eax
    jmp isr_main

.align 8
isr_cpu_entry_241:
    movl $241, %eax
    jmp isr_main

.align 8
isr_cpu_entry_242:
    movl $242, %eax
    jmp isr_main

.align 8
isr_cpu_entry_243:
    movl $243, %eax
    jmp isr_main

.align 8
isr_cpu_entry_244:
    movl $244, %eax
    jmp isr_main

.align 8
isr_cpu_entry_245:
    movl $245, %eax
    jmp isr_main

.align 8
isr_cpu_entry_246:
    movl $246, %eax
    jmp isr_main

.align 8
isr_cpu_entry_247:
    movl $247, %eax
    jmp isr_main

.align 8
isr_cpu_entry_248:
    movl $248, %eax
    jmp isr_main

.align 8
isr_cpu_entry_249:
    movl $249, %eax
    jmp isr_main

.align 8
isr_cpu_entry_250:
    movl $250, %eax
    jmp isr_main

.align 8
isr_cpu_entry_251:
    movl $251, %eax
    jmp isr_main

.align 8
isr_cpu_entry_252:
    movl $252, %eax
    jmp isr_main

.align 8
isr_cpu_entry_253:
    movl $253, %eax
    jmp isr_main

.align 8
isr_cpu_entry_254:
    movl $254, %eax
    jmp isr_main

.align 8
isr_cpu_entry_255:
    movl $255, %eax
    jmp isr_main

.globl isr_cpu_entry_paths_end
isr_cpu_entry_paths_end:

.section .rodata, "a", @progbits
.globl isr_cpu_entry_path_list
.align 8
isr_cpu_entry_path_list:
    .quad isr_cpu_entry_0
    .quad isr_cpu_entry_1
    .quad isr_cpu_entry_2
    .quad isr_cpu_entry_3
    .quad isr_cpu_entry_4
    .quad isr_cpu_entry_5
    .quad isr_cpu_entry_6
    .quad isr_cpu_entry_7
    .quad isr_cpu_entry_8
    .quad isr_cpu_entry_9
    .quad isr_cpu_entry_10
    .quad isr_cpu_entry_11
    .quad isr_cpu_entry_12
    .quad isr_cpu_entry_13
    .quad isr_cpu_entry_14
    .quad isr_cpu_entry_15
    .quad isr_cpu_entry_16
    .quad isr_cpu_entry_17
    .quad isr_cpu_entry_18
    .quad isr_cpu_entry_19
    .quad isr_cpu_entry_20
    .quad isr_cpu_entry_21
    .quad isr_cpu_entry_22
    .quad isr_cpu_entry_23
    .quad isr_cpu_entry_24
    .quad isr_cpu_entry_25
    .quad isr_cpu_entry_26
    .quad isr_cpu_entry_27
    .quad isr_cpu_entry_28
    .quad isr_cpu_entry_29
    .quad isr_cpu_entry_30
    .quad isr_cpu_entry_31
    .quad isr_cpu_entry_32
    .quad isr_cpu_entry_33
    .quad isr_cpu_entry_34
    .quad isr_cpu_entry_35
    .quad isr_cpu_entry_36
    .quad isr_cpu_entry_37
    .quad isr_cpu_entry_38
    .quad isr_cpu_entry_39
    .quad isr_cpu_entry_40
    .quad isr_cpu_entry_41
    .quad isr_cpu_entry_42
    .quad isr_cpu_entry_43
    .quad isr_cpu_entry_44
    .quad isr_cpu_entry_45
    .quad isr_cpu_entry_46
    .quad isr_cpu_entry_47
    .quad isr_cpu_entry_48
    .quad isr_cpu_entry_49
    .quad isr_cpu_entry_50
    .quad isr_cpu_entry_51
    .quad isr_cpu_entry_52
    .quad isr_cpu_entry_53
    .quad isr_cpu_entry_54
    .quad isr_cpu_entry_55
    .quad isr_cpu_entry_56
    .quad isr_cpu_entry_57
    .quad isr_cpu_entry_58
    .quad isr_cpu_entry_59
    .quad isr_cpu_entry_60
    .quad isr_cpu_entry_61
    .quad isr_cpu_entry_62
    .quad isr_cpu_entry_63
    .quad isr_cpu_entry_64
    .quad isr_cpu_entry_65
    .quad isr_cpu_entry_66
    .quad isr_cpu_entry_67
    .quad isr_cpu_entry_68
    .quad isr_cpu_entry_69
    .quad isr_cpu_entry_70
    .quad isr_cpu_entry_71
    .quad isr_cpu_entry_72
    .quad isr_cpu_entry_73
    .quad isr_cpu_entry_74
    .quad isr_cpu_entry_75
    .quad isr_cpu_entry_76
    .quad isr_cpu_entry_77
    .quad isr_cpu_entry_78
    .quad isr_cpu_entry_79
    .quad isr_cpu_entry_80
    .quad isr_cpu_entry_81
    .quad isr_cpu_entry_82
    .quad isr_cpu_entry_83
    .quad isr_cpu_entry_84
    .quad isr_cpu_entry_85
    .quad isr_cpu_entry_86
    .quad isr_cpu_entry_87
    .quad isr_cpu_entry_88
    .quad isr_cpu_entry_89
    .quad isr_cpu_entry_90
    .quad isr_cpu_entry_91
    .quad isr_cpu_entry_92
    .quad isr_cpu_entry_93
    .quad isr_cpu_entry_94
    .quad isr_cpu_entry_95
    .quad isr_cpu_entry_96
    .quad isr_cpu_entry_97
    .quad isr_cpu_entry_98
    .quad isr_cpu_entry_99
    .quad isr_cpu_entry_100
    .quad isr_cpu_entry_101
    .quad isr_cpu_entry_102
    .quad isr_cpu_entry_103
    .quad isr_cpu_entry_104
    .quad isr_cpu_entry_105
    .quad isr_cpu_entry_106
    .quad isr_cpu_entry_107
    .quad isr_cpu_entry_108
    .quad isr_cpu_entry_109
    .quad isr_cpu_entry_110
    .quad isr_cpu_entry_111
    .quad isr_cpu_entry_112
    .quad isr_cpu_entry_113
    .quad isr_cpu_entry_114
    .quad isr_cpu_entry_115
    .quad isr_cpu_entry_116
    .quad isr_cpu_entry_117
    .quad isr_cpu_entry_118
    .quad isr_cpu_entry_119
    .quad isr_cpu_entry_120
    .quad isr_cpu_entry_121
    .quad isr_cpu_entry_122
    .quad isr_cpu_entry_123
    .quad isr_cpu_entry_124
    .quad isr_cpu_entry_125
    .quad isr_cpu_entry_126
    .quad isr_cpu_entry_127
    .quad isr_cpu_entry_128
    .quad isr_cpu_entry_129
    .quad isr_cpu_entry_130
    .quad isr_cpu_entry_131
    .quad isr_cpu_entry_132
    .quad isr_cpu_entry_133
    .quad isr_cpu_entry_134
    .quad isr_cpu_entry_135
    .quad isr_cpu_entry_136
    .quad isr_cpu_entry_137
    .quad isr_cpu_entry_138
    .quad isr_cpu_entry_139
    .quad isr_cpu_entry_140
    .quad isr_cpu_entry_141
    .quad isr_cpu_entry_142
    .quad isr_cpu_entry_143
    .quad isr_cpu_entry_144
    .quad isr_cpu_entry_145
    .quad isr_cpu_entry_146
    .quad isr_cpu_entry_147
    .quad isr_cpu_entry_148
    .quad isr_cpu_entry_149
    .quad isr_cpu_entry_150
    .quad isr_cpu_entry_151
    .quad isr_cpu_entry_152
    .quad isr_cpu_entry_153
    .quad isr_cpu_entry_154
    .quad isr_cpu_entry_155
    .quad isr_cpu_entry_156
    .quad isr_cpu_entry_157
    .quad isr_cpu_entry_158
    .quad isr_cpu_entry_159
    .quad isr_cpu_entry_160
    .quad isr_cpu_entry_161
    .quad isr_cpu_entry_162
    .quad isr_cpu_entry_163
    .quad isr_cpu_entry_164
    .quad isr_cpu_entry_165
    .quad isr_cpu_entry_166
    .quad isr_cpu_entry_167
    .quad isr_cpu_entry_168
    .quad isr_cpu_entry_169
    .quad isr_cpu_entry_170
    .quad isr_cpu_entry_171
    .quad isr_cpu_entry_172
    .quad isr_cpu_entry_173
    .quad isr_cpu_entry_174
    .quad isr_cpu_entry_175
    .quad isr_cpu_entry_176
    .quad isr_cpu_entry_177
    .quad isr_cpu_entry_178
    .quad isr_cpu_entry_179
    .quad isr_cpu_entry_180
    .quad isr_cpu_entry_181
    .quad isr_cpu_entry_182
    .quad isr_cpu_entry_183
    .quad isr_cpu_entry_184
    .quad isr_cpu_entry_185
    .quad isr_cpu_entry_186
    .quad isr_cpu_entry_187
    .quad isr_cpu_entry_188
    .quad isr_cpu_entry_189
    .quad isr_cpu_entry_190
    .quad isr_cpu_entry_191
    .quad isr_cpu_entry_192
    .quad isr_cpu_entry_193
    .quad isr_cpu_entry_194
    .quad isr_cpu_entry_195
    .quad isr_cpu_entry_196
    .quad isr_cpu_entry_197
    .quad isr_cpu_entry_198
    .quad isr_cpu_entry_199
    .quad isr_cpu_entry_200
    .quad isr_cpu_entry_201
    .quad isr_cpu_entry_202
    .quad isr_cpu_entry_203
    .quad isr_cpu_entry_204
    .quad isr_cpu_entry_205
    .quad isr_cpu_entry_206
    .quad isr_cpu_entry_207
    .quad isr_cpu_entry_208
    .quad isr_cpu_entry_209
    .quad isr_cpu_entry_210
    .quad isr_cpu_entry_211
    .quad isr_cpu_entry_212
    .quad isr_cpu_entry_213
    .quad isr_cpu_entry_214
    .quad isr_cpu_entry_215
    .quad isr_cpu_entry_216
    .quad isr_cpu_entry_217
    .quad isr_cpu_entry_218
    .quad isr_cpu_entry_219
    .quad isr_cpu_entry_220
    .quad isr_cpu_entry_221
    .quad isr_cpu_entry_222
    .quad isr_cpu_entry_223
    .quad isr_cpu_entry_224
    .quad isr_cpu_entry_225
    .quad isr_cpu_entry_226
    .quad isr_cpu_entry_227
    .quad isr_cpu_entry_228
    .quad isr_cpu_entry_229
    .quad isr_cpu_entry_230
    .quad isr_cpu_entry_231
    .quad isr_cpu_entry_232
    .quad isr_cpu_entry_233
    .quad isr_cpu_entry_234
    .quad isr_cpu_entry_235
    .quad isr_cpu_entry_236
    .quad isr_cpu_entry_237
    .quad isr_cpu_entry_238
    .quad isr_cpu_entry_239
    .quad isr_cpu_entry_240
    .quad isr_cpu_entry_241
    .quad isr_cpu_entry_242
    .quad isr_cpu_entry_243
    .quad isr_cpu_entry_244
    .quad isr_cpu_entry_245
    .quad isr_cpu_entry_246
    .quad isr_cpu_entry_247
    .quad isr_cpu_entry_248
    .quad isr_cpu_entry_249
    .quad isr_cpu_entry_250
    .quad isr_cpu_entry_251
    .quad isr_cpu_entry_252
    .quad isr_cpu_entry_253
    .quad isr_cpu_entry_254
    .quad isr_cpu_entry_255
