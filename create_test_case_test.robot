#############################################################################################################
#   © 2020-2023 Nokia. Nokia confidential and proprietary.                                                  #
#   Licensed materials restricted solely to Nokia authorized users for legitimate business purposes only.   #
#   The actual or attempted unauthorized use or modification of this code is strictly prohibited by Nokia.  #
#   Use pursuant to Company instructions.                                                                   #
#############################################################################################################

*** Settings ***
Documentation        This test is intended to test LAG resiliency feature

Resource             sats.robot
Suite Setup          Initialization
Suite Teardown       Finalization

Metadata    nta_tcid    FL-3

*** Variables ***

${R5_hostname}                                  10.10.10.5          #DUT IP Address
${R5_username}                                  admin               #DUT username
${R5_password}                                  N0K5A-SATS          #DUT password

${R5_lag_id}                                    56                  #LAG ID 

${traffic_generator_client_ip}                  10.10.10.7          #Traffic Generator Client IP Address
${traffic_generator_client_port}                8888                #Traffic Generator Client Port
${traffic_generator_type}                       STC.REST            #IXIA.Rest, STC.Rest, TCPReplay or iPerf3
${traffic_generator_file_name}                  lag_link_resiliency.xml   #Traffic Generator Template File Name 

*** Test Cases ***
Check LAG State And Port State

    ${oper_status}                              Get LAG Oper Status
    ...                                         ${R5_lag_id}
         
    IF                              '${oper_status.upper()}' != 'UP'
      Fail     LAG ${R5_lag_id} is not in UP state
    END
    Send SROS Command And Log 
    ...                                         show lag ${R5_lag_id}

    ${up_ports}                                 Get Up Ports List in a Lag
    ...                                         ${R5_lag_id}

    Set Suite Variable                          ${up_ports}

    ${up_port_count}                            Get Length   ${up_ports}
         
    IF                               '${up_port_count}' < '2'
      Fail     LAG ${R5_lag_id} doesn't have at least two up ports
    END
    Log To Report                               Up port count is ${up_port_count}

    Set Suite Variable                          ${up_port_count}                            

    Send SROS Command And Log 
    ...                                         show lag ${R5_lag_id} port                                     

    FOR  ${item}  IN  @{up_ports}

        Send SROS Command And Log 
        ...                                     show port ${item} | match expression "Admin State|Oper State"

    END

Check That LAG Not Receive Any Traffic

    ${command}                                  Monitor Command For All Ports
    ...                                         ${up_ports}

    ${output}                                   Send SROS Command And Parse
    ...                                         ${command}

    ${first_results}                            Construct Tree From Lists   ${output}

    ${sum_of_packets}                           Set Variable    0   

    FOR  ${item}  IN  @{up_ports}

        ${sum_of_packets}=                      Evaluate    
        ...                                     ${first_results['3 sec']['${item}']['Packets'][1][1]} + ${sum_of_packets}
    END

    ${average}                                  Evaluate
    ...                                         ${sum_of_packets} / ${up_port_count}

    IF                              ${average} > 1000
      Fail     LAG ${R5_lag_id} is receiving traffic
    END

    ${output}                                   Get Last SROS Command Output

    ${output_with_command}                      Catenate        ${command}     \n${output}

    Log To Report With Prompt                   ${output_with_command}

Start Traffic And Check That Lag Receiving Traffic

    Start Traffic

    Log To Console                              \nWaiting 10 seconds for traffic flow
    Log To Report                               Waiting 10 seconds for traffic flow
    Sleep                                       10 

    ${command}                                  Monitor Command For All Ports
    ...                                         ${up_ports}

    ${output}                                   Send SROS Command And Parse
    ...                                         ${command}

    ${traffic_results}                          Construct Tree From Lists    ${output}

    Calculate Mbits and Verify Traffic State For All Ports
    ...                                         ${traffic_results}
    ...                                         ${up_ports}

    ${output}                                   Get Last SROS Command Output

    ${output_with_command}                      Catenate        ${command}     \n${output}

    Log To Report With Prompt                   ${output_with_command}

Fail One Port And Check Other Port Receiving All Traffic

    Send SROS Command And Log 
    ...                                         /configure port ${up_ports[0]} shutdown

    FOR  ${item}  IN  @{up_ports}

        Send SROS Command And Log 
        ...                                     show port ${item} | match expression "Admin State|Oper State"

    END

    Sleep                                       2

    ${shut_port}                                Set Variable
    ...                                         ${up_ports[0]}

    Set Suite Variable                          ${shut_port}

    Remove Values From List
    ...                                         ${up_ports}
    ...                                         ${up_ports[0]}                                 

    ${command}=                                 Monitor Command For All Ports
    ...                                         ${up_ports}

    ${output}                                   Send SROS Command And Parse
    ...                                         ${command}                        

    ${traffic_results}                          Construct Tree From Lists    ${output}

    Calculate Mbits and Verify Traffic State For All Ports
    ...                                         ${traffic_results}
    ...                                         ${up_ports}

    ${output}                                   Get Last SROS Command Output

    ${output_with_command}                      Catenate        ${command}     \n${output}

    Log To Report With Prompt                   ${output_with_command}

    Stop Traffic

Get Traffic Results And Revert Changes

    ${droprate}                                 Log Results

    Should Be True                              ${droprate} <= 0.05
    ...                                         Drop rate is not lower than 0.05

    Send SROS Command And Log 
    ...                                         /configure port ${shut_port} no shutdown

    Sleep                                       1

    ${last_up_ports}                            Get Up Ports List in a Lag
    ...                                         ${R5_lag_id}

    ${len}                                      Get Length   ${last_up_ports}

    Should Be True                              '${len}' == '${up_port_count}'
    ...                                         Initial and last operational up port count for LAG ${R5_lag_id} is not same

    FOR  ${item}  IN  @{last_up_ports}

        Send SROS Command And Log 
        ...                                     show port ${item} | match expression "Admin State|Oper State"

    END

*** Keywords ***
Initialization
  SROS Connect
  ...  sros_address=${R5_hostname}
  ...  username=${R5_username}
  ...  password=${R5_password}
  ...  timeout=5 minutes
  ...  port=22

Finalization
  SROS Disconnect All
  Close Traffic Generator Session

Get Up Ports List in a Lag
  [Arguments]                                   ${lag-id}

  ${output}=                                    Send SROS Command And Parse
  ...                                           show lag ${lag-id} port

  ${lag_up_ports}=                              Filter Table By Values
  ...                                           rowlist=${output}
  ...                                           searchcolumn=5
  ...                                           searchvalues=up

  ${lag_up_ports_list}=                         Create List
  
  FOR  ${up_ports}  IN  @{lag_up_ports}
    
    IF                                      "${up_ports[4]}" != "down"
      Append To List                         ${lag_up_ports_list}  ${up_ports[2]}
    END
  END

  [Return]                                      ${lag_up_ports_list}

Monitor Command For All Ports
    
    [Arguments]
    ...                                     ${ports}

    ${len}                                  Get Length   ${ports}

    ${command}                              Set Variable    ${EMPTY}
    FOR  ${item}  IN RANGE  ${len}

        ${command}=                         Catenate        ${ports[${item}].strip()}     ${command.strip()}
  
    END
    #Including all ports to one command
   
    IF                                      '${len}' == '1'
      ${command}                            Set Variable  monitor port ${ports[0]} rate interval 3 repeat 
    
    ELSE    
      ${command}                            Set Variable  monitor port ${command} rate interval 3 repeat 1
    
    END

    [Return]                                ${command}

Calculate Mbits and Verify Traffic State For All Ports

    [Arguments]
    ...             ${results}
    ...             ${ports}

    ${sum_of_octets}=                       Set Variable    0

    ${len}                                  Get Length      ${ports}

    #Getting all output octets to calculate average

    FOR  ${item}  IN  @{ports}
           
        IF                                  '${len}' == '1'
          ${item}                           Set Variable  Port ${item}
        
        ELSE    
          ${item}                            Set Variable  ${item}
        
        END

        ${sum_of_octets}=                   Evaluate    
        ...                                 ${results['3 sec']['${item}']['Octets'][1][1]} + ${sum_of_octets}
    END

    ${average}                              Evaluate
    ...                                     ${sum_of_octets} / ${len}

    Log To Report                           Sum of all port octets are ${sum_of_octets}
    
    #Calculating average Mbps value for all ports
    ${mbits}                                Evaluate
    ...                                     ${average} / 1048576

    ${x}                                    Convert To Number      ${mbits}  1                     

    Log To Report                           Average for all port rate is ${x} Mbps

    #Setting threshold value to half of average
    ${threshold_value}                      Evaluate
    ...                                     ${mbits} * 0.5

    #Minimum value for traffic flow
    ${min_value}                            Evaluate
    ...                                     ${mbits} - ${threshold_value}

    ${x}                                    Convert To Number      ${min_value}  1

    Log To Report                           Expected minimum rate value is ${x} Mbps
    #Maximum value for traffic flow
    ${max_value}                            Evaluate
    ...                                     ${mbits} + ${threshold_value}

    ${x}                                    Convert To Number      ${max_value}  1
    Log To Report                           Expected maximum rate value is ${x} Mbps

    #Comparing port statistics with average port value, if port rate is lower than related minimum value of port rate is higher than related max value test will fail
    FOR  ${item}  IN   @{ports}
                       

        IF                                  '${len}' == '1'
          ${item}                           Set Variable  Port ${item}
        
        ELSE    
          ${item}                           Set Variable  ${item}
        
        END

        ${mbits_port}                       Evaluate
        ...                                 ${results['3 sec']['${item}']['Octets'][1][1]} / 1048576
        ${x}                                Convert To Number      ${mbits_port}  1
        Log To Report                       For port ${item} rate is ${x} Mbps

        Should Be True                      ${min_value} <= ${mbits_port}   Octets for ${item} is not higher than Min value, port rate is ${x}
        Should Be True                      ${max_value} >= ${mbits_port}   Octets for ${item} is higher than Max value, port rate is ${x}

    END

Start Traffic

    ###Connecting to Tester
    Use Traffic Generator
    ...                                     generator=${traffic_generator_type}

    Open Traffic Generator Session
    ...                                     hostname=${traffic_generator_client_ip}
    ...                                     port=${traffic_generator_client_port}
    ...                                     timeout=1000

    ###Applying Configuration File
    Apply Configuration From File
    ...                                     filename=${traffic_generator_file_name}

    ###Starting Traffic

    Start Traffic Generation

Stop Traffic

    ###Stopping Traffic

    Stop Traffic Generation

Log Results

  ${results}=         Get Traffic Results

  ${txframes}=        Get Transmitted Frame Count
  ${rxframes}=        Get Received Frame Count
  ${dropcount}=       Get Dropped Frame Count
  ${droppercent}=     Get Dropped Frame Percentage

  Log To Report       \nTransmitted Frames: ${txframes}\nReceived Frames: ${rxframes}\nDropped Frames: ${dropcount}\nDrop Rate: ${droppercent} %
  Log To Console      \nTransmitted Frames: ${txframes}\nReceived Frames: ${rxframes}\nDropped Frames: ${dropcount}\nDrop Rate: ${droppercent} %
  Should Be True      int(${txframes}) > 0
  Should Be True      int(${rxframes}) > 0

  [Return]            ${droppercent}
