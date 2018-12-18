--カオス・フォーム
function c21082832.initial_effect(c)
	aux.AddRitualProcEqual2(c,c21082832.filter,nil,c21082832.mfilter)
end
c21082832.card_code_list={46986414,89631139}
function c21082832.filter(c,e,tp,m1,m2,ft)
	return c:IsSetCard(0xcf)
end
function c21082832.mfilter(c)
	return c:IsCode(46986414,89631139)
end
