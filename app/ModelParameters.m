classdef ModelParameters
    properties (Access = public)
        
        %-- percentage of exposed and recovered for each population
        % admin / teachers
        exp_at
        rec_at
        % staff
        exp_staff
        rec_staff
        % students
        exp_students
        rec_students
        
        %-- alpha: exposed infectiousness
        exposed_infect
        %-- percentage of non-compliant students
        nc_students
        %-- percentage of contact-tracing students
        ct_students
        
        %-- number of outside contacts for each pop
        oc_at
        oc_staff
        oc_students
    end
   
    methods
      function obj = ModelParameters()
        % set default parameters here
        
      end
    end
    
end

