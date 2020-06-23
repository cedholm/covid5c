classdef SubPops

    properties
        totalSusPop
        totalExpPop
        totalInfPop
        totalRecPop
        totalMedPop
        totalDeadPop
        totalHeldPop

        susAdminTeach
        expAdminTeach
        infAdminTeach
        recAdminTeach
        medAdminTeach
        deadAdminTeach
        held_sAdminTeach
        held_eAdminTeach
        heldAdminTeach

        susStaff
        expStaff
        infStaff
        recStaff
        medStaff
        deadStaff
        held_sStaff
        held_eStaff
        heldStaff

        susStud
        expStud
        infStud
        recStud
        medStud
        deadStud
        held_sStud
        held_eStud
        held_iStud
        heldStud
    end

    methods
        function res = SubPops(y)

            % Sums
            res.totalSusPop = 0;
            res.totalExpPop = 0;
            res.totalInfPop = 0;
            res.totalRecPop = 0;
            res.totalMedPop = 0;
            res.totalDeadPop = 0;
            res.totalHeldPop = 0;

            % Admin/Teaching
            n = 0; % categories 1 - 4
            res.susAdminTeach = y(:,8*n+1) + y(:,8*(n+1)+1) + y(:,8*(n+2)+1) + y(:,8*(n+3)+1);
            res.expAdminTeach = y(:,8*n+2) + y(:,8*(n+1)+2) + y(:,8*(n+2)+2) + y(:,8*(n+3)+2);
            res.infAdminTeach = y(:,8*n+3) + y(:,8*(n+1)+3) + y(:,8*(n+2)+3) + y(:,8*(n+3)+3);
            res.recAdminTeach = y(:,8*n+4) + y(:,8*(n+1)+4) + y(:,8*(n+2)+4) + y(:,8*(n+3)+4);
            res.medAdminTeach = y(:,8*n+5) + y(:,8*(n+1)+5) + y(:,8*(n+2)+5) + y(:,8*(n+3)+5);
            res.deadAdminTeach = y(:,8*n+6) + y(:,8*(n+1)+6) + y(:,8*(n+2)+6) + y(:,8*(n+3)+6);
            res.held_sAdminTeach = y(:,8*n+7) + y(:,8*(n+1)+7) + y(:,8*(n+2)+7) + y(:,8*(n+3)+7);
            res.held_eAdminTeach = y(:,8*n+8) + y(:,8*(n+1)+8) + y(:,8*(n+2)+8) + y(:,8*(n+3)+8);
            res.heldAdminTeach = res.held_sAdminTeach + res.held_eAdminTeach;


            % Staff
            n = 4; % categories 5 - 8
            res.susStaff = y(:,8*n+1) + y(:,8*(n+1)+1) + y(:,8*(n+2)+1) + y(:,8*(n+3)+1);
            res.expStaff = y(:,8*n+2) + y(:,8*(n+1)+2) + y(:,8*(n+2)+2) + y(:,8*(n+3)+2);
            res.infStaff = y(:,8*n+3) + y(:,8*(n+1)+3) + y(:,8*(n+2)+3) + y(:,8*(n+3)+3);
            res.recStaff = y(:,8*n+4) + y(:,8*(n+1)+4) + y(:,8*(n+2)+4) + y(:,8*(n+3)+4);
            res.medStaff = y(:,8*n+5) + y(:,8*(n+1)+5) + y(:,8*(n+2)+5) + y(:,8*(n+3)+5);
            res.deadStaff = y(:,8*n+6) + y(:,8*(n+1)+6) + y(:,8*(n+2)+6) + y(:,8*(n+3)+6);
            res.held_sStaff = y(:,8*n+7) + y(:,8*(n+1)+7) + y(:,8*(n+2)+7) + y(:,8*(n+3)+7);
            res.held_eStaff = y(:,8*n+8) + y(:,8*(n+1)+8) + y(:,8*(n+2)+8) + y(:,8*(n+3)+8);
            res.heldStaff = res.held_sStaff + res.held_eStaff;


            % Students
            n = 8; % categories 9 and 10
            res.susStud = y(:,8*n+1) + y(:,8*(n+1)+1);
            res.expStud = y(:,8*n+2) + y(:,8*(n+1)+2);
            res.infStud = y(:,8*n+3) + y(:,8*(n+1)+3);
            res.recStud = y(:,8*n+4) + y(:,8*(n+1)+4);
            res.medStud = y(:,8*n+5) + y(:,8*(n+1)+5);
            res.deadStud = y(:,8*n+6) + y(:,8*(n+1)+6);
            res.held_sStud = y(:,8*n+7) + y(:,8*(n+1)+7);
            res.held_eStud = y(:,8*n+8) + y(:,8*(n+1)+8);

            % Non-compliant Students
            res.held_iStud = y(:,end);
            res.heldStud = res.held_sStud + res.held_eStud + res.held_iStud;

            for i = 1:80
                if mod(i,8) == 1
                    res.totalSusPop = res.totalSusPop + y(:, i);
                end
                if mod (i, 8) == 2
                    res.totalExpPop = res.totalExpPop + y(:, i);
                end
                if mod (i, 8) == 3
                    res.totalInfPop = res.totalInfPop + y(:, i);
                end
                if mod (i, 8) == 4
                    res.totalRecPop = res.totalRecPop + y(:, i);
                end
                if mod (i, 8) == 5
                    res.totalMedPop = res.totalMedPop + y(:, i);
                end
                if mod (i, 8) == 6
                    res.totalDeadPop = res.totalDeadPop + y(:, i);
                end
                if mod (i, 8) == 0
                    res.totalHeldPop = res.totalHeldPop + y(:, i);
                end
            end
            res.totalHeldPop = res.totalHeldPop + y(:,end);  % add H_I for NC Students

        end % constructor


        function extract(obj, label)
            switch(label)
                case ''
            end
        end % extract
    end % methods
end % class
