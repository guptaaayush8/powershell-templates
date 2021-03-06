<?xml version="1.0" encoding="UTF-16"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var" exclude-result-prefixes="msxsl var s0 userCSharp" version="1.0" xmlns:ns0="http://schemas.microsoft.com/BizTalk/EDI/X12/2006" xmlns:s0="http://Lyo.BizTalk.ExciseTax_813.ExciseTax_813_XML" xmlns:userCSharp="http://schemas.microsoft.com/BizTalk/2003/userCSharp">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="/s0:ExciseTax_813" />
  </xsl:template>
  <xsl:template match="/s0:ExciseTax_813">
    <xsl:variable name="var:v1" select="userCSharp:StringConcat(&quot;813&quot;)" />
    <xsl:variable name="var:v2" select="userCSharp:StringConcat(&quot;0001&quot;)" />
    <xsl:variable name="var:v5" select="userCSharp:LogicalEq(&quot;CCR&quot; , string(EDIHeader/TFS_RefIdentification_Constant/text()))" />
    <xsl:variable name="var:v7" select="userCSharp:LogicalEq(&quot;SU&quot; , string(EDIHeader/Ref_Identification_Qulf1/text()))" />
    <xsl:variable name="var:v9" select="string(EDIHeader/Ref_Identification_Qulf1/text())" />
    <xsl:variable name="var:v10" select="userCSharp:LogicalEq(&quot;SU&quot; , $var:v9)" />
    <xsl:variable name="var:v13" select="userCSharp:LogicalEq(string(EDIHeader/Ref_Identification_Qulf2/text()) , &quot;55&quot;)" />
    <xsl:variable name="var:v16" select="string(EDIHeader/Ref_Identification_Qulf2/text())" />
    <xsl:variable name="var:v17" select="userCSharp:LogicalNe(&quot;55&quot; , $var:v16)" />
    <ns0:X12_00403_813>
      <ST>
        <ST01>
          <xsl:value-of select="$var:v1" />
        </ST01>
        <ST02>
          <xsl:value-of select="$var:v2" />
        </ST02>
      </ST>
      <ns0:BTI>
        <BTI01>
          <xsl:value-of select="EDIHeader/BTI_RefIdentification_Qulf/text()" />
        </BTI01>
        <BTI02>
          <xsl:value-of select="EDIHeader/BTI_Ref_Identification/text()" />
        </BTI02>
        <BTI03>
          <xsl:value-of select="EDIHeader/BTI_Identification_CodeQulf/text()" />
        </BTI03>
        <BTI04>
          <xsl:value-of select="EDIHeader/BTI_Identification_Code/text()" />
        </BTI04>
        <xsl:variable name="var:v3" select="userCSharp:GetToDayDate()" />
        <BTI05>
          <xsl:value-of select="$var:v3" />
        </BTI05>
        <xsl:variable name="var:v4" select="userCSharp:CompStr(string(EDIHeader/CompanyName/text()))" />
        <BTI06>
          <xsl:value-of select="$var:v4" />
        </BTI06>
        <BTI07>
          <xsl:value-of select="EDIHeader/BTI_Identification_CodeQulf2/text()" />
        </BTI07>
        <BTI08>
          <xsl:value-of select="EDIHeader/TaxId/text()" />
        </BTI08>
        <BTI10>
          <xsl:value-of select="EDIHeader/PermitNumber/text()" />
        </BTI10>
        <BTI13>
          <xsl:value-of select="EDIHeader/PurposeCode/text()" />
        </BTI13>
        <BTI14>
          <xsl:value-of select="EDIHeader/TypeCode/text()" />
        </BTI14>
      </ns0:BTI>
      <ns0:DTM>
        <DTM01>
          <xsl:value-of select="EDIHeader/DTM_DateTimeQlf/text()" />
        </DTM01>
        <DTM02>
          <xsl:value-of select="EDIHeader/ReportingDate/text()" />
        </DTM02>
      </ns0:DTM>
      <ns0:TIA>
        <ns0:C037>
          <C03701>
            <xsl:value-of select="EDIHeader/TIA_TaxInfo_Identification_Num2/text()" />
          </C03701>
        </ns0:C037>
        <TIA04>
          <xsl:value-of select="Summary/TotalConvQty/text()" />
        </TIA04>
        <ns0:C001>
          <C00101>
            <xsl:value-of select="EDIHeader/TIA_Unit_Of_Measurement/text()" />
          </C00101>
        </ns0:C001>
      </ns0:TIA>
      <ns0:N1Loop1>
        <ns0:N1>
          <N101>
            <xsl:value-of select="EDIHeader/N1_EntityIdentification_Code/text()" />
          </N101>
          <N102>
            <xsl:value-of select="EDIHeader/CompanyName/text()" />
          </N102>
        </ns0:N1>
        <ns0:N3>
          <N301>
            <xsl:value-of select="EDIHeader/AddressLine1/text()" />
          </N301>
          <N302>
            <xsl:value-of select="EDIHeader/AddressLine2/text()" />
          </N302>
        </ns0:N3>
        <ns0:N4>
          <N401>
            <xsl:value-of select="EDIHeader/City/text()" />
          </N401>
          <N402>
            <xsl:value-of select="EDIHeader/State/text()" />
          </N402>
          <N403>
            <xsl:value-of select="EDIHeader/Zip/text()" />
          </N403>
          <N404>
            <xsl:value-of select="EDIHeader/N4_CountryCode/text()" />
          </N404>
        </ns0:N4>
        <ns0:PER>
          <PER01>
            <xsl:value-of select="EDIHeader/PER_Contact_FnCode/text()" />
          </PER01>
          <PER02>
            <xsl:value-of select="EDIHeader/ContactName/text()" />
          </PER02>
          <PER03>
            <xsl:value-of select="EDIHeader/PER_CommNum_Qualifier/text()" />
          </PER03>
          <PER04>
            <xsl:value-of select="EDIHeader/ContactPhone/text()" />
          </PER04>
          <PER05>
            <xsl:value-of select="EDIHeader/PER_CommNum_Qualifier2/text()" />
          </PER05>
          <PER06>
            <xsl:value-of select="EDIHeader/FaxPhone/text()" />
          </PER06>
          <PER07>
            <xsl:value-of select="EDIHeader/PER_CommNum_Qualifier3/text()" />
          </PER07>
          <PER08>
            <xsl:value-of select="EDIHeader/Email/text()" />
          </PER08>
        </ns0:PER>
      </ns0:N1Loop1>
      <ns0:TFSLoop1>
        <ns0:TFS>
          <xsl:if test="string($var:v5)='true'">
            <xsl:variable name="var:v6" select="userCSharp:StringConcat(&quot;T2&quot;)" />
            <TFS01>
              <xsl:value-of select="$var:v6" />
            </TFS01>
          </xsl:if>
          <TFS02>
            <xsl:value-of select="EDIHeader/TFS_RefIdentification_Constant/text()" />
          </TFS02>
        </ns0:TFS>
        <ns0:REF_2>
          <REF01>
            <xsl:value-of select="EDIHeader/Ref_Identification_Qulf1/text()" />
          </REF01>
          <xsl:if test="string($var:v7)='true'">
            <xsl:variable name="var:v8" select="userCSharp:StringConcat(&quot;IRS&quot;)" />
            <REF02>
              <xsl:value-of select="$var:v8" />
            </REF02>
          </xsl:if>
          <ns0:C040_2>
            <xsl:if test="string($var:v10)='true'">
              <xsl:variable name="var:v11" select="userCSharp:StringConcat(&quot;S0&quot;)" />
              <C04001>
                <xsl:value-of select="$var:v11" />
              </C04001>
            </xsl:if>
            <xsl:if test="string($var:v10)='true'">
              <xsl:variable name="var:v12" select="EDIHeader/State/text()" />
              <C04002>
                <xsl:value-of select="$var:v12" />
              </C04002>
            </xsl:if>
          </ns0:C040_2>
        </ns0:REF_2>
        <ns0:REF_2>
          <REF01>
            <xsl:value-of select="EDIHeader/Ref_Identification_Qulf2/text()" />
          </REF01>
          <xsl:if test="string($var:v13)='true'">
            <xsl:variable name="var:v14" select="position()" />
            <xsl:variable name="var:v15" select="userCSharp:MyHdrCnt(string($var:v14))" />
            <REF02>
              <xsl:value-of select="$var:v15" />
            </REF02>
          </xsl:if>
          <xsl:if test="$var:v17">
            <xsl:variable name="var:v18" select="userCSharp:LogicalEq($var:v16 , &quot;55&quot;)" />
            <ns0:C040_2>
              <xsl:if test="string($var:v18)='true'">
                <xsl:variable name="var:v19" select="userCSharp:StringConcat(&quot;&quot;)" />
                <C04001>
                  <xsl:value-of select="$var:v19" />
                </C04001>
              </xsl:if>
              <xsl:if test="string($var:v18)='true'">
                <xsl:variable name="var:v20" select="userCSharp:StringConcat(&quot;&quot;)" />
                <C04002>
                  <xsl:value-of select="$var:v20" />
                </C04002>
              </xsl:if>
            </ns0:C040_2>
          </xsl:if>
        </ns0:REF_2>
        <ns0:TIALoop1>
          <ns0:TIA_2>
            <ns0:C037_2>
              <C03701>
                <xsl:value-of select="EDIHeader/TIA_TaxInfo_Identification_Num3/text()" />
              </C03701>
            </ns0:C037_2>
            <TIA04>
              <xsl:value-of select="Summary/TotalConvQty/text()" />
            </TIA04>
            <ns0:C001_2>
              <C00101>
                <xsl:value-of select="EDIHeader/TIA_Unit_Of_Measurement/text()" />
              </C00101>
            </ns0:C001_2>
          </ns0:TIA_2>
        </ns0:TIALoop1>
      </ns0:TFSLoop1>
      <xsl:for-each select="DetailGroup">
        <xsl:variable name="var:v21" select="position()" />
        <xsl:variable name="var:v22" select="userCSharp:LogicalEq(&quot;SU&quot; , string(DET_Header/Ref_Identification_Qulf1/text()))" />
        <xsl:variable name="var:v24" select="string(DET_Header/Ref_Identification_Qulf1/text())" />
        <xsl:variable name="var:v25" select="userCSharp:LogicalEq(&quot;SU&quot; , $var:v24)" />
        <xsl:variable name="var:v30" select="userCSharp:LogicalEq(string(DET_Header/Ref_Identification_Qulf2/text()) , &quot;55&quot;)" />
        <xsl:variable name="var:v32" select="string(DET_Header/Ref_Identification_Qulf2/text())" />
        <xsl:variable name="var:v33" select="userCSharp:LogicalNe(&quot;55&quot; , $var:v32)" />
        <xsl:variable name="var:v37" select="userCSharp:LogicalEq(&quot;CI&quot; , string(DET_Header/N1_Entity_Identification_Code2/text()))" />
        <xsl:variable name="var:v39" select="string(DET_Header/N1_Entity_Identification_Code2/text())" />
        <xsl:variable name="var:v40" select="userCSharp:LogicalEq(&quot;CI&quot; , $var:v39)" />
        <xsl:variable name="var:v43" select="userCSharp:LogicalEq(&quot;CA&quot; , string(DET_Header/N1_Entity_Identification_Code3/text()))" />
        <xsl:variable name="var:v46" select="string(DET_Header/N1_Entity_Identification_Code3/text())" />
        <xsl:variable name="var:v47" select="userCSharp:LogicalEq(&quot;CA&quot; , $var:v46)" />
        <xsl:variable name="var:v50" select="userCSharp:LogicalEq(&quot;DT&quot; , string(DET_Header/TermQualifier/text()))" />
        <xsl:variable name="var:v52" select="string(DET_Header/TermQualifier/text())" />
        <xsl:variable name="var:v53" select="userCSharp:LogicalEq(&quot;OT&quot; , $var:v52)" />
        <xsl:variable name="var:v55" select="userCSharp:LogicalEq(&quot;DT&quot; , $var:v52)" />
        <ns0:TFSLoop1>
          <ns0:TFS>
            <TFS01>
              <xsl:value-of select="DET_Header/TFS_Ref_Identification_Qulf/text()" />
            </TFS01>
            <TFS02>
              <xsl:value-of select="DET_Header/ScheduleType/text()" />
            </TFS02>
            <TFS03>
              <xsl:value-of select="DET_Header/TFS_Ref_Identification_Qulf2/text()" />
            </TFS03>
            <TFS04>
              <xsl:value-of select="DET_Header/IRSPRDCode/text()" />
            </TFS04>
            <TFS05>
              <xsl:value-of select="DET_Header/TFS_Identification_CodeQulf/text()" />
            </TFS05>
            <TFS06>
              <xsl:value-of select="DET_Header/ShipMode/text()" />
            </TFS06>
          </ns0:TFS>
          <ns0:REF_2>
            <REF01>
              <xsl:value-of select="DET_Header/Ref_Identification_Qulf1/text()" />
            </REF01>
            <xsl:if test="string($var:v22)='true'">
              <xsl:variable name="var:v23" select="userCSharp:StringConcat(&quot;IRS&quot;)" />
              <REF02>
                <xsl:value-of select="$var:v23" />
              </REF02>
            </xsl:if>
            <ns0:C040_2>
              <xsl:if test="string($var:v25)='true'">
                <xsl:variable name="var:v26" select="userCSharp:StringConcat(&quot;S0&quot;)" />
                <C04001>
                  <xsl:value-of select="$var:v26" />
                </C04001>
              </xsl:if>
              <xsl:if test="string($var:v25)='true'">
                <xsl:variable name="var:v27" select="../EDIHeader/State/text()" />
                <C04002>
                  <xsl:value-of select="$var:v27" />
                </C04002>
              </xsl:if>
              <xsl:if test="string($var:v25)='true'">
                <xsl:variable name="var:v28" select="userCSharp:StringConcat(&quot;S0&quot;)" />
                <C04003>
                  <xsl:value-of select="$var:v28" />
                </C04003>
              </xsl:if>
              <xsl:if test="string($var:v25)='true'">
                <xsl:variable name="var:v29" select="../EDIHeader/State/text()" />
                <C04004>
                  <xsl:value-of select="$var:v29" />
                </C04004>
              </xsl:if>
            </ns0:C040_2>
          </ns0:REF_2>
          <ns0:REF_2>
            <REF01>
              <xsl:value-of select="DET_Header/Ref_Identification_Qulf2/text()" />
            </REF01>
            <xsl:if test="string($var:v30)='true'">
              <xsl:variable name="var:v31" select="userCSharp:MyHdrCnt(string($var:v21))" />
              <REF02>
                <xsl:value-of select="$var:v31" />
              </REF02>
            </xsl:if>
            <xsl:if test="$var:v33">
              <xsl:variable name="var:v34" select="userCSharp:LogicalEq($var:v32 , &quot;55&quot;)" />
              <ns0:C040_2>
                <xsl:if test="string($var:v34)='true'">
                  <xsl:variable name="var:v35" select="userCSharp:StringConcat(&quot;&quot;)" />
                  <C04001>
                    <xsl:value-of select="$var:v35" />
                  </C04001>
                </xsl:if>
                <xsl:if test="string($var:v34)='true'">
                  <xsl:variable name="var:v36" select="userCSharp:StringConcat(&quot;&quot;)" />
                  <C04002>
                    <xsl:value-of select="$var:v36" />
                  </C04002>
                </xsl:if>
              </ns0:C040_2>
            </xsl:if>
          </ns0:REF_2>
          <ns0:N1Loop2>
            <ns0:N1_2>
              <N101>
                <xsl:value-of select="DET_Header/N1_Entity_Identification_Code2/text()" />
              </N101>
              <xsl:if test="string($var:v37)='true'">
                <xsl:variable name="var:v38" select="userCSharp:CompStr(string(../EDIHeader/CompanyName/text()))" />
                <N102>
                  <xsl:value-of select="$var:v38" />
                </N102>
              </xsl:if>
              <xsl:if test="string($var:v40)='true'">
                <xsl:variable name="var:v41" select="DET_Header/N1_Identification_CodeQulf3/text()" />
                <N103>
                  <xsl:value-of select="$var:v41" />
                </N103>
              </xsl:if>
              <xsl:if test="string($var:v40)='true'">
                <xsl:variable name="var:v42" select="DET_Header/CompanyTaxId/text()" />
                <N104>
                  <xsl:value-of select="$var:v42" />
                </N104>
              </xsl:if>
            </ns0:N1_2>
          </ns0:N1Loop2>
          <ns0:N1Loop2>
            <ns0:N1_2>
              <N101>
                <xsl:value-of select="DET_Header/N1_Entity_Identification_Code3/text()" />
              </N101>
              <xsl:if test="string($var:v43)='true'">
                <xsl:variable name="var:v44" select="string(../EDIHeader/CompanyName/text())" />
                <xsl:variable name="var:v45" select="userCSharp:CompStr($var:v44)" />
                <N102>
                  <xsl:value-of select="$var:v45" />
                </N102>
              </xsl:if>
              <xsl:if test="string($var:v47)='true'">
                <xsl:variable name="var:v48" select="DET_Header/N1_Identification_CodeQulf2/text()" />
                <N103>
                  <xsl:value-of select="$var:v48" />
                </N103>
              </xsl:if>
              <xsl:if test="string($var:v47)='true'">
                <xsl:variable name="var:v49" select="../EDIHeader/TaxId/text()" />
                <N104>
                  <xsl:value-of select="$var:v49" />
                </N104>
              </xsl:if>
            </ns0:N1_2>
          </ns0:N1Loop2>
          <ns0:N1Loop2>
            <ns0:N1_2>
              <N101>
                <xsl:value-of select="DET_Header/TermQualifier/text()" />
              </N101>
              <xsl:if test="string($var:v50)='true'">
                <xsl:variable name="var:v51" select="DET_Header/N1_Identification_CodeQulf/text()" />
                <N103>
                  <xsl:value-of select="$var:v51" />
                </N103>
              </xsl:if>
              <xsl:if test="string($var:v53)='true'">
                <xsl:variable name="var:v54" select="DET_Header/N1_Identification_CodeQulf/text()" />
                <N103>
                  <xsl:value-of select="$var:v54" />
                </N103>
              </xsl:if>
              <xsl:if test="string($var:v55)='true'">
                <xsl:variable name="var:v56" select="DET_Header/TerminalNum/text()" />
                <N104>
                  <xsl:value-of select="$var:v56" />
                </N104>
              </xsl:if>
              <xsl:if test="string($var:v53)='true'">
                <xsl:variable name="var:v57" select="DET_Header/TerminalNum/text()" />
                <N104>
                  <xsl:value-of select="$var:v57" />
                </N104>
              </xsl:if>
            </ns0:N1_2>
          </ns0:N1Loop2>
          <xsl:for-each select="DET_Record">
            <xsl:variable name="var:v58" select="position()" />
            <ns0:FGSLoop1>
              <ns0:FGS>
                <FGS01>
                  <xsl:value-of select="FGS_Assigned_Identification/text()" />
                </FGS01>
                <FGS02>
                  <xsl:value-of select="FGS_Ref_Identification_Qulf/text()" />
                </FGS02>
                <FGS03>
                  <xsl:value-of select="MatDocNum/text()" />
                </FGS03>
              </ns0:FGS>
              <ns0:REF_3>
                <REF01>
                  <xsl:value-of select="../../EDIHeader/Ref_Identification_Qulf2/text()" />
                </REF01>
                <xsl:variable name="var:v59" select="userCSharp:MyConcat(string($var:v58))" />
                <REF02>
                  <xsl:value-of select="$var:v59" />
                </REF02>
              </ns0:REF_3>
              <ns0:DTM_4>
                <DTM01>
                  <xsl:value-of select="DTM_DateTimeQulf/text()" />
                </DTM01>
                <DTM02>
                  <xsl:value-of select="MatDocPostDate/text()" />
                </DTM02>
              </ns0:DTM_4>
              <ns0:TIALoop2>
                <ns0:TIA_3>
                  <ns0:C037_3>
                    <C03701>
                      <xsl:value-of select="TIA_TaxInfo_Idfn_Num/text()" />
                    </C03701>
                  </ns0:C037_3>
                  <TIA04>
                    <xsl:value-of select="ConvQty/text()" />
                  </TIA04>
                  <ns0:C001_3>
                    <C00101>
                      <xsl:value-of select="TIA_Unit_Of_Measurement/text()" />
                    </C00101>
                  </ns0:C001_3>
                </ns0:TIA_3>
              </ns0:TIALoop2>
              <ns0:TIALoop2>
                <ns0:TIA_3>
                  <ns0:C037_3>
                    <C03701>
                      <xsl:value-of select="TIA_TaxInfo_Idfn_Num2/text()" />
                    </C03701>
                  </ns0:C037_3>
                  <TIA04>
                    <xsl:value-of select="ConvQty/text()" />
                  </TIA04>
                  <ns0:C001_3>
                    <C00101>
                      <xsl:value-of select="TIA_Unit_Of_Measurement/text()" />
                    </C00101>
                  </ns0:C001_3>
                </ns0:TIA_3>
              </ns0:TIALoop2>
            </ns0:FGSLoop1>
          </xsl:for-each>
        </ns0:TFSLoop1>
      </xsl:for-each>
    </ns0:X12_00403_813>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="userCSharp"><![CDATA[
public string StringConcat(string param0)
{
   return param0;
}


public string GetToDayDate()
{
              string strDate = "";
              string strMonth = "";
              string strDay = "";
              strDate= System.DateTime.Now.Year.ToString();

              strMonth = System.DateTime.Now.Month.ToString();
              if(strMonth.Length == 1)
               {
                   strDate += "0";  //System.DateTime.Now.Month.ToString();
                   strDate += strMonth;
                }
              else
                    strDate += strMonth;

              strDay = System.DateTime.Now.Day.ToString();
              if(strDay.Length == 1)
              {
                     strDate += "0";
                     strDate += strDay;
               }
               else
                    strDate += strDay;

            //  strDate += System.DateTime.Now.Day.ToString();
	return strDate;
}

public string CompStr(string param)
{
	return param.Substring(0,4);
}

// Define Global variables

int i = 20000;

int hdr = 10000;

public bool LogicalEq(string val1, string val2)
{
	bool ret = false;
	double d1 = 0;
	double d2 = 0;
	if (IsNumeric(val1, ref d1) && IsNumeric(val2, ref d2))
	{
		ret = d1 == d2;
	}
	else
	{
		ret = String.Compare(val1, val2, StringComparison.Ordinal) == 0;
	}
	return ret;
}


public int MyHdrCnt(string param1)
{
              hdr= hdr+1;
	return hdr;
}

public bool LogicalNe(string val1, string val2)
{
	bool ret = false;
	double d1 = 0;
	double d2 = 0;
	if (IsNumeric(val1, ref d1) && IsNumeric(val2, ref d2))
	{
		ret = d1 != d2;
	}
	else
	{
		ret = String.Compare(val1, val2, StringComparison.Ordinal) != 0;
	}
	return ret;
}


public int MyConcat(string param1)
{
              i = i+1;
	return i;
}

public bool IsNumeric(string val)
{
	if (val == null)
	{
		return false;
	}
	double d = 0;
	return Double.TryParse(val, System.Globalization.NumberStyles.AllowThousands | System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out d);
}

public bool IsNumeric(string val, ref double d)
{
	if (val == null)
	{
		return false;
	}
	return Double.TryParse(val, System.Globalization.NumberStyles.AllowThousands | System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out d);
}


]]></msxsl:script>
</xsl:stylesheet>