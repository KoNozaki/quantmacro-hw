clc
clear all
close all

f = fred;

startdate = '01/01/1960';
enddate = '01/01/2019';

sgp_data = fetch(f, 'RGDPNASGA666NRUG', startdate, enddate);
jpn_data = fetch(f, 'RGDPNAJPA666NRUG', startdate, enddate);

% 1. シンガポールの対数実質GDPにHP-filterをかけ、トレンドを除去する
sgp_gdp = sgp_data.Data(:, 2);
sgp_gdp_log = log(sgp_gdp);
sgp_cycle = hpfilter(sgp_gdp_log, 1600); % HPフィルター適用
sgp_detrended = sgp_gdp_log - sgp_cycle;

% 2. 日本についても対数実質GDPにHP-filterをかけてトレンドを除去する
jpn_gdp = jpn_data.Data(:, 2);
jpn_gdp_log = log(jpn_gdp);
jpn_cycle = hpfilter(jpn_gdp_log, 1600); % HPフィルター適用
jpn_detrended = jpn_gdp_log - jpn_cycle;

% 3. シンガポールのGDPの標準偏差、日本のGDPの標準偏差、シンガポールと日本のGDPの間の相関係数を計算
sgp_std = std(sgp_detrended);
jpn_std = std(jpn_detrended);
corr_sg_jp = corrcoef(sgp_detrended, jpn_detrended);
corr_sg_jp = corr_sg_jp(1, 2);

fprintf('シンガポールの循環変動成分の標準偏差: %.4f\n', sgp_std);
fprintf('日本の循環変動成分の標準偏差: %.4f\n', jpn_std);
fprintf('シンガポールと日本の循環変動成分の相関係数: %.4f\n', corr_sg_jp);

% 4. 両国のDetrended logを比較するグラフを作成する
years = datetime(sgp_data.Data(:, 1), 'ConvertFrom', 'datenum');
figure
plot(years, sgp_detrended, 'b', years, jpn_detrended, 'r')
legend('Singapore', 'Japan')
title('Detrended Log Real GDP')
xlabel('Year')
ylabel('Detrended Log Real GDP')
grid on