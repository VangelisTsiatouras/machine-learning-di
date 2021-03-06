% K Nearest Neighbors Implementation
function k_nn(Train_array, Train_array_pos, Train_array_response, Test_array, Test_array_pos, Test_array_response, Operational_array, Operational_array_pos, Operational_array_response)

    % Plot datasets   
    complete_dataset_array_response = [Train_array_response Test_array_response Operational_array_response];
    complete_dataset_array_pos = [Train_array_pos; Test_array_pos; Operational_array_pos];
    plot_dataset(complete_dataset_array_pos, complete_dataset_array_response, 'Complete Dataset');
    drawnow('update');
    
    k = '';
   
    % Command prompts to initialize k with users desired value
    cont1 = true;
    while(cont1)
        
        cont2 = true;
        while (cont2)
            prompt = 'Enter number of k neighbors (integers 1-17 are allowed)\n';
            k = input(prompt);
            if(k >= 1 && k <= 17)
                cont2 = false;
            end
        end
        
        % Make a 5-fold cross validation
        k_nn_5_fold_cross_validation (Train_array, Train_array_pos, Train_array_response, k);
        
        cont3 = true;
        while(cont3)
            prompt = 'Do you wish to continue classification with this value of k? (y/n)\n';
            answer = input(prompt,'s');
            if (isequal(answer, 'y') || isequal(answer, 'Y'))
                cont1 = false;
                cont3 = false;
            elseif (isequal(answer, 'n') || isequal(answer, 'N'))
                cont1 = true;
                cont3 = false;
            else
                cont3 = true;
            end
        end
    end
    
    tic;
    
    fprintf('##########################\n');
    fprintf('        TEST SET\n')
    fprintf('##########################\n');
    [accuracy, test_set_estimations] = k_nn_algorithm(Train_array, Train_array_response, Test_array, Test_array_response, k);
    
    fprintf('\n##########################\n');
    fprintf('      OPERATIONAL SET\n')
    fprintf('##########################\n');
    [accuracy, operational_set_estimations] = k_nn_algorithm(Train_array, Train_array_response, Operational_array, Operational_array_response, k);
    
    result_array_response = [Train_array_response test_set_estimations operational_set_estimations];
    result_array_pos = [Train_array_pos; Test_array_pos; Operational_array_pos];
    plot_dataset(result_array_pos, result_array_response, 'k-NN Result');
    
    time = toc;
    fprintf('\nClassification Execution Time (cross validation execution time is excluded): %f seconds\n', time);
end