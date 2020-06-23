classdef PlotController
    
    properties
        results ModelResults
        pops SubPops
    end
    
    methods
        
        function obj = PlotController()
            %obj.results = ModelResults();
            %obj.pops = SubPops(obj.results);
        end
        
        function obj = update(obj, results)
            obj.results = results;
            obj.pops = SubPopulations(results.y);
        end
        
        function plot(ax, obj, keys, xlab, ylab)
            cla(ax);
            for i=1:length(keys)
                x = obj.results.t;
                y = obj.pops.get(keys(i));
                plot(ax, x, y);
                xlabel(ax, xlab);
                ylabel(ax, ylab);
                hold on;
            end
        end
    end
    
end