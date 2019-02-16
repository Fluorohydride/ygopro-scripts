--希望皇オノマトピア
function c8512558.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(8512558,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,8512558)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c8512558.sptg)
	e1:SetOperation(c8512558.spop)
	c:RegisterEffect(e1)
end
function c8512558.spfilter(c,e,tp,set)
	return c:IsSetCard(set) and not c:IsCode(8512558) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c8512558.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(c8512558.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,0x54)
		or Duel.IsExistingMatchingCard(c8512558.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,0x59)
		or Duel.IsExistingMatchingCard(c8512558.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,0x82)
		or Duel.IsExistingMatchingCard(c8512558.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,0x8f))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c8512558.spop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c8512558.spfilter,tp,LOCATION_HAND,0,nil,e,tp,0x54)
	local g2=Duel.GetMatchingGroup(c8512558.spfilter,tp,LOCATION_HAND,0,nil,e,tp,0x59)
	local g3=Duel.GetMatchingGroup(c8512558.spfilter,tp,LOCATION_HAND,0,nil,e,tp,0x82)
	local g4=Duel.GetMatchingGroup(c8512558.spfilter,tp,LOCATION_HAND,0,nil,e,tp,0x8f)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 and (#g1>0 or #g2>0 or #g3>0 or #g4>0) then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local sg=Group.CreateGroup()
		if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0 and g4:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(8512558,1))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=g1:Select(tp,1,1,nil)
			sg:Merge(sg1)
			ft=ft-1
		end
		if g2:GetCount()>0 and ft>0 and ((sg:GetCount()==0 and g3:GetCount()==0 and g4:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(8512558,2))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=g2:Select(tp,1,1,nil)
			sg:Merge(sg2)
			ft=ft-1
		end
		if g3:GetCount()>0 and ft>0 and ((sg:GetCount()==0 and g4:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(8512558,3))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg3=g3:Select(tp,1,1,nil)
			sg:Merge(sg3)
			ft=ft-1
		end
		if g4:GetCount()>0 and ft>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(8512558,4))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg4=g4:Select(tp,1,1,nil)
			sg:Merge(sg4)
		end
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c8512558.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c8512558.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
