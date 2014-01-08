function [ register_data_hwk_kompakt ] = register_fill( register_start, data_struct, prog_scope, prog_detail)
%Assigns register address hex values to the register address structure
%   register_start has to be the start address, consider that holding
%   register starts with 0. Data_struct has to be the register address
%   structure, prog_scope the forecast scope and prog_detail the forecast
%   detail. E.g. [data] =
%   register_fill(420,register_data_hwk_kompakt,'niederschlag','menge')

% Get all fieldnames of register address structure
scope_fields = fieldnames(data_struct);

% Loop through all forecast scopes
for u = 1:numel(scope_fields)
% If loop value equals prog_scope, get the available forecast details for
% this forecast scope
    if strcmp(scope_fields{u},prog_scope) == 1
        detail_fields = fieldnames(data_struct.(scope_fields{u}));
% Loop through all forecast details
            for r = 1:numel(detail_fields)
% If loop value equals prog_detail, get the available forecast days
                if strcmp(detail_fields{r},prog_detail) == 1
                        day_fields = fieldnames(data_struct.(scope_fields{u}).(detail_fields{r}));
                        day_fields_num = numel(fieldnames(data_struct.(scope_fields{u}).(detail_fields{r})));
% Loop through all forecast days, get the forecast hours for the specific
% day
                    for t = 1:day_fields_num
                        hour_fields = fieldnames(data_struct.(scope_fields{u}).(detail_fields{r}).(day_fields{t}));
% Loop through all hours and write hex values starting from register_start,
% increase register_start by 1 after each loop.
                        for s = 1:numel(hour_fields)
                                data_struct.(scope_fields{u}).(detail_fields{r}).(day_fields{t}).(hour_fields{s}) = dec2hex(register_start,4);
                                register_start = register_start + 1;
                        end
                    end
                end
            end
    end
end
% Write register with hex addresses to output
register_data_hwk_kompakt = data_struct;
end

