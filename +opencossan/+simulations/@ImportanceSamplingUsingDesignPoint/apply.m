function [simData, weights] = apply(obj, model)
    %APPLY Creates samples using the simulations object and applys the model to it.
    validateattributes(model, {'opencossan.reliability.ProbabilisticModel'}, {'scalar'}); 
    
    if isempty(obj.DesignPoint)
        obj.DesignPoint = model.designPointIdentification();
    end
    
    [samples, weights] = obj.sample('input', model.Input);
    simData = model.apply(samples);
end