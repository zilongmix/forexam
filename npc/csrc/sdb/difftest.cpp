#include "difftest.h"
#include "assert.h"
#include "simtop.h"

extern Simtop* mysim_p;

Difftest::Difftest(/* args */) {

    cout << "difftest start" << endl;
}
Difftest::~Difftest() {

    cout << "difftest stop" << endl;
}

/**
 * @brief 初始化 difftest
 *
 * @param ref_so_file 动态链接库文件名称
 * @param img_size 程序镜像大小
 * @param port 未使用
 */
void Difftest::init(const char* ref_so_file, long img_size, int port) {
    assert(ref_so_file != NULL);
    void* handle;
    handle = dlopen(ref_so_file, RTLD_LAZY);
    assert(handle);
    diff_memcpy = (ref_Difftest_memcpy)dlsym(handle, "difftest_memcpy");
    assert(diff_memcpy);
    diff_regcpy = (ref_Difftest_regcpy)dlsym(handle, "difftest_regcpy");
    assert(diff_regcpy);
    diff_exec = (ref_Difftest_exec)dlsym(handle, "difftest_exec");
    assert(diff_exec);
    diff_raise_intr = (ref_Difftest_raise_intr)dlsym(handle, "difftest_raise_intr");
    assert(diff_raise_intr);
    diff_init = (ref_difftest_init)dlsym(handle, "difftest_init");
    assert(diff_init);

    diff_init(port);

    uint64_t membase = mysim_p->mem->getMEMBASE();
    /* 将程序镜像文件拷贝过去 */
    diff_memcpy(membase, mysim_p->mem->guest_to_host(membase), img_size, DIFFTEST_TO_REF);
    CPU_state regs = getDutregs();
    /* 让 dut 和 ref 寄存器初始值一样 */
    diff_regcpy(&regs, DIFFTEST_TO_REF);
}

/**
 * @brief 获取 dut 寄存器组
 *
 * @return Difftest::CPU_state
 */
Difftest::CPU_state Difftest::getDutregs() {
    CPU_state regs;
    for (size_t i = 0; i < 32; i++) {
        regs.gpr[i] = mysim_p->getRegVal(i);
    }
    regs.pc = mysim_p->getRegVal("pc");
    return regs;
}
/**
 * @brief 获取 nemu 寄存器组
 *
 * @return Difftest::CPU_state
 */
Difftest::CPU_state Difftest::getRefregs() {
    CPU_state regs;
    diff_regcpy(&regs, DIFFTEST_TO_DUT);
    return regs;
}
/**
 * @brief 比较 ref 与 dut 的寄存器
 *
 * @param ref
 * @return true 完全相同
 * @return false 不同
 */
bool Difftest::checkregs() {
    bool ret = true;
    CPU_state dutregs = getDutregs();
    CPU_state refregs = getRefregs();
    for (size_t i = 0; i < 32; i++) {
        if (dutregs.gpr[i] != refregs.gpr[i]) {
            cout << "num:" << i << "err!!" << endl;
            return false;

        }
    }
    if (dutregs.pc != refregs.pc) {
        cout << "pc:err" << endl;
        return false;
    }
    return true;
}
/**
 * @brief 让 nemu 执行一条指令,并且进行 difftest
 *
 */
void Difftest::difftest_step() {
    /* 寄存器不一样 */
    diff_exec(1);
    if (!checkregs()) {
        mysim_p->top_status = mysim_p->TOP_STOP;
    }
}