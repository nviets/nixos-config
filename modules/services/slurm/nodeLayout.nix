{ config, lib, pkgs, ... }: {
  services = with pkgs; {
    slurm = {
      nodeName = [
        "superx10 Sockets=4 RealMemory=200000 CoresPerSocket=24 ThreadsPerCore=2 State=UNKNOWN"
      ];
      partitionName = [
        "superx10 Nodes=sparkler Default=NO MaxTime=INFINITE State=UP"
      ];
      extraConfig = ''
        SlurmctldHost=mini
        SlurmctldHost=sparkler
        SlurmctldLogFile=/var/log/slurm/slurmctld.log
        SlurmdLogFile=/var/log/slurm/slurmd.log
        #FastSchedule=1
        SchedulerType=sched/backfill
        SelectType=select/cons_tres
        ReturnToService=1
        TaskPlugin=task/cgroup
        InactiveLimit=0
        KillWait=30
        MinJobAge=300
        SlurmctldTimeout=120
        SlurmdTimeout=300
        Waittime=0
      '';
      extraCgroupConfig = ''
        #CgroupAutomount=yes
        CgroupMountpoint=/sys/fs/cgroup
        ConstrainCores=yes
        ConstrainDevices=yes
        ConstrainRAMSpace=yes
        ConstrainSwapSpace=yes
      '';
    };
  };
}
