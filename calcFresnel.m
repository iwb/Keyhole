function [ Az ] = calcFresnel( pVec, n, params )
%CALCFRESNEL Summary of this function goes here
%   Detailed explanation goes here

global AAzz mu;
epsilon = params.epsilon;

% Skalarprodukt zwischen Poyntingvektor & Normalenvektor
mu = sum(-n .* pVec)'; % Spaltenweises Skalarprodukt


% Fresnel Absorption
Ap = 4*epsilon .* mu ./ (2*mu.^2 + 2*epsilon .* mu + epsilon^2);
As = 4*epsilon .*mu ./ (2 + 2*epsilon .* mu + epsilon^2 .* mu.^2);
Az = (As + Ap)/2;

AAzz = Az;
end

