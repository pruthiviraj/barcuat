<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_DCL_Copy_Total_Amount</fullName>
        <field>Copy_Total_Value__c</field>
        <formula>Total_Amount__c</formula>
        <name>Update DCL Copy Total Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Copy Amount</fullName>
        <actions>
            <name>Update_DCL_Copy_Total_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
