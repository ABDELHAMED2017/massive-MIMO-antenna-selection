function HG = Genetic(H)
%
%input H = N x Nr ά�ŵ�����
%output  HG ����ѡ�����ŵ����� 

%�̳в���
N = size(H,2); %Number of transmit antennas (in total)


%% �Ŵ��㷨������ʼ��
maxgen=20;                         %��������������������
sizepop=10;                        %��Ⱥ��ģ��������Ⱥ�е�Ⱦɫ������
pcross=[0.2];                       %�������ѡ��0��1֮��
pmutation=[0.2];                    %�������ѡ��0��1֮��

%�ڵ�����
numsum=N;

lenchrom=ones(1,numsum);   %��ʼ��Ⱦɫ���еĻ������г���length_of_chrom 
%��Ҫ�޸�bound    
bound=[-1*ones(numsum,1) 1*ones(numsum,1)];    %���ݷ�Χ

%------------------------------------------------------��Ⱥ��ʼ��--------------------------------------------------------
individuals=struct('fitness',zeros(1,sizepop), 'chrom',[]);  %����Ⱥ��Ϣ����Ϊһ���ṹ��
avgfitness=[];                      %ÿһ����Ⱥ��ƽ����Ӧ��
bestfitness=[];                     %ÿһ����Ⱥ�������Ӧ��
bestchrom=[];                       %��Ӧ����õ�Ⱦɫ��
%��ʼ����Ⱥ
for i=1:sizepop
    %�������һ����Ⱥ
    individuals.chrom(i,:)=sort01(Code(lenchrom,bound));    %���루binary��grey�ı�����Ϊһ��ʵ����float�ı�����Ϊһ��ʵ��������
    x=individuals.chrom(i,:);
    %������Ӧ��
	%��Ҫ�޸�fun����
    individuals.fitness(i)=fun(x,H);   %Ⱦɫ�����Ӧ��
end
FitRecord=[];
%����õ�Ⱦɫ��
%��Ҫ�޸����Ⱦɫ���Ѱ�ҷ���
[bestfitness bestindex]=max(individuals.fitness);
bestchrom=individuals.chrom(bestindex,:);  %��õ�Ⱦɫ��
avgfitness=sum(individuals.fitness)/sizepop; %Ⱦɫ���ƽ����Ӧ��
% ��¼ÿһ����������õ���Ӧ�Ⱥ�ƽ����Ӧ��
trace=[avgfitness bestfitness]; 
 
%% ���������ѳ�ʼ��ֵ��Ȩֵ
% ������ʼ
for i=1:maxgen
    disp(num2str(i));%չʾ�Ŵ�����
    % ѡ��
    individuals=Select(individuals,sizepop); 
    avgfitness=sum(individuals.fitness)/sizepop;
    %����
    individuals.chrom=Cross(pcross,lenchrom,individuals.chrom,sizepop,bound);
	 for i = 1:sizepop
		individuals.chrom(i,:) = sort01(individuals.chrom(i,:));
    end
    % ����
    individuals.chrom=Mutation(pmutation,lenchrom,individuals.chrom,sizepop,i,maxgen,bound);
    for i = 1:sizepop
		individuals.chrom(i,:) = sort01(individuals.chrom(i,:));
    end
    % ������Ӧ�� 
    for j=1:sizepop
        x=individuals.chrom(j,:); %����
        individuals.fitness(j)=fun(x,H);   
    end
    
  %�ҵ���С�������Ӧ�ȵ�Ⱦɫ�弰��������Ⱥ�е�λ��
  %Ҳ��Ҫ�������
  
    [newbestfitness,newbestindex]=max(individuals.fitness);
	
    [worestfitness,worestindex]=min(individuals.fitness);
    % ������һ�ν�������õ�Ⱦɫ��
    if newbestfitness>bestfitness
        bestfitness=newbestfitness;
        bestchrom=individuals.chrom(newbestindex,:);
    end
    individuals.chrom(worestindex,:)=bestchrom;
    individuals.fitness(worestindex)=bestfitness;
    
    avgfitness=sum(individuals.fitness)/sizepop;
    
    trace=[trace;avgfitness bestfitness]; %��¼ÿһ����������õ���Ӧ�Ⱥ�ƽ����Ӧ��
    FitRecord=[FitRecord;individuals.fitness];
end
D = bestchrom;
HG =Htrans(H,D);
