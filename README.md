# MusicAnalysis_SignalSystem

五个music.m均为为最终成果的测试程序，返回值pno与p分别表示最终结果（乐谱）与乐音区所有帧频率（测试使用，直接使用不需要频率调出）
pno为两列的矩阵，第一列为音符，第二列为音符的时间位置

musicz为直接法，musicc为自相关法，musich为谐波峰值法，musiczh为直接法谐波峰值法混合，musicch为自相关法与谐波峰值法混合

输入格式为
>\>> [y,fs]=wavread('C:\Users\11033\Desktop\WAV\Various Artists _new.wav');
>\>> x=y(:,1);%如果输入y为双声道则需此步骤取单声道，若y本身为单声道则可忽略此步骤
>\>> [pnoz,pz]=musicz(x,fs);
>\>> [pnoc,pc]=musicc(x,fs);
>\>> [pnoh,ph]=musich(x,fs);
>\>> [pnozh,pzh]=musiczh(x,fs);
>\>> [pnoch,pch]=musicch(x,fs);
>\>> [pz pc ph pzh pch]%若要看对比图需要此步骤，否则不必
>\>> [pnoz pnoc pnoh pnozh pnoch]%注意pnoh可能与其他向量长度不一致，需补齐后使用此步，或舍弃pnoh
