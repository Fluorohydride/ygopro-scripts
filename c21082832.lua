--カオス・フォーム
function c21082832.initial_effect(c)
	aux.AddCodeList(c,46986414,89631139)
	aux.AddRitualProcEqual2(c,c21082832.filter,nil,c21082832.mfilter)
end
function c21082832.filter(c,e,tp,m1,m2,ft)
	return c:IsSetCard(0xcf)
end
function c21082832.mfilter(c)
	return c:IsCode(46986414,89631139)
end
