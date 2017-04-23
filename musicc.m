function [ pno,p ] = musicc( y,fs )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
L=length(y);
N=fs/9;
H=0;
a=1.2;
b=0.9;
n=N;
silencenum=0;
musicnum=0;
z=1;
pitch=0;
zz=1;

if L>N%初始门限
    H=a*sum(y(1:N).^2)/N;
end

while (n<L-N)
    nowpower=sum(y(1+n:N+n).^2)/N;%当前帧能量
    if nowpower>H
        musicnum=musicnum+1;
        silencenum=0;%静音计数归零
        if musicnum>=3%乐音区
            f=fre(y(1+n:N+n),fs);%频率分析
            nowpitch=judge(f);%音阶分析
            p(zz,1)=f;
            zz=zz+1;
            if pitch==0||pitch~=nowpitch%首次进入乐音区或音阶变化
                nummu=1;%开始音区记录
                pitch=nowpitch;
            elseif pitch==nowpitch
                nummu=nummu+1;%相同音次数加一
            end
            if nummu==2%次数为2记录音符
                %write(pitch);
                pno(z,1)=pitch;
                pno(z,2)=n/L;
                z=z+1;
            end
        end
    elseif nowpower<H
        silencenum=silencenum+1;
        musicnum=0;%乐音计数归零
        if silencenum>=3%乐音区结束，进入静音区
            pitch=0;%音阶记录归零，音符终点
            H=H*b+(1-b)*nowpower*a;%门限修正
            nummu=0;
        end
    end
    n=n+N;
end

end

function [basicf] = xcorrelation( x,fs )
     N=length(x);
    a=0.5;
    m=0;
     for i=1:N
        if abs(x(i,1))>m
            n=i;
            m=abs(x(i,1));
        end
    end
    L=a*m;
    for i=1:N%电平削波
        if x(i,1)>L
            x(i,1)=1;
        elseif x(i,1)<-L
            x(i,1)=-1;
        else
            x(i,1)=0;
        end
    end
    a=abs(xcorr(x));
    item=0;
    for i=1:N/2%最大值的次数算法
        if a(i,1)>item
            n=i;
            item=a(i,1);
        end
    end
    basicf=n*fs/N;
end

function f = fre( x,fs )
    f0=xcorrelation(x,fs);
    Wp=f0*2*pi;Ws=2*f0*2*pi;Rp=3;Rs=20;
    [n,Wn]=buttord(Wp,Ws,Rp,Rs,'s');
    [z,p,k]=buttap(n);
    [Bap,Aap]=zp2tf(z,p,k);
    [b,a]=lp2lp(Bap,Aap,Wn);
    [bz,az]=impinvar(b,a,fs);
    y=filter(bz,az,x);
    m=abs(fft(y));
    item=0;
    N=length(m);
    h=0;
    for i=1:N%最大值的次数算法
        if m(i,1)>item
            h=i;
            item=m(i,1);
        end
    end
    f=h*fs/N;
end

function H =judge(f)
if f<2060&&f>1940;
	H=203;
elseif f<1940&&f>1834;
	H=113;
elseif f<1834&&f>1730;
	H=103;
elseif f<1730&&f>1630;
	H=713;
elseif f<1630&&f>1532;
	H=703;
elseif f<1532&&f>1460;
	H=613;
elseif f<1460&&f>1380;
	H=603;
elseif f<1380&&f>1300;
	H=503;
elseif f<1300&&f>1224;
	H=413;
elseif f<1224&&f>1150;
	H=403;
elseif f<1150&&f>1080;
	H=313;
elseif f<1080&&f>1030;
	H=303;
elseif f<1030&&f>970;
    H=202;
elseif f<970&&f>915;
    H=112;
elseif f<915&&f>865;
	H=102;
elseif f<865&&f>815;
	H=712;
elseif f<815&&f>770;
	H=702;
elseif f<770&&f>730;
	H=612;
elseif f<730&&f>690;
	H=602;
elseif f<690&&f>655;
	H=502;
elseif f<655&&f>612;
	H=412;
elseif f<612&&f>580;
	H=402;
elseif f<580&&f>548
	H=312;
elseif f<548&&f>517;
	H=302;
elseif f<517&&f>487;
	H=201;
elseif f<487&&f>460;
	H=111;
elseif f<460&&f>435;
	H=101;
elseif f<435&&f>410;
	H=711;
elseif f<410&&f>387;
	H=701;
elseif f<387&&f>364;
	H=611;
elseif f<364&&f>344;
	H=601;
elseif f<344&&f>325;
	H=501;
elseif f<325&&f>307;
	H=411;
elseif f<307&&f>290;
	H=401;
elseif f<290&&f>274;
	H=311;
elseif f<274&&f>258;
	H=301;
elseif f<258&&f>243;
	H=200;
elseif f<243&&f>230;
	H=110;
elseif f<230&&f>218;
	H=100;
elseif f<218&&f>205;
	H=710;
elseif f<205&&f>194;
	H=700;
elseif f<194&&f>183;
	H=610;
elseif f<183&&f>172;
	H=600;
elseif f<172&&f>162;
	H=500;
elseif f<162&&f>153;
	H=410;
elseif f<153&&f>144;
	H=400;
elseif f<144&&f>136;
	H=310;
elseif f<136&&f>128;
	H=300;
else H=-1;
end
end
