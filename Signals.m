classdef(Enumeration) Signals < Simulink.IntEnumType
    enumeration
        GSR(1),
        ECG(2),
        RSP(3),
        OBD(4),
        ECG_RAW(5),
        GSR_RAW(6),
        BELT_RAW(7)
    end
end