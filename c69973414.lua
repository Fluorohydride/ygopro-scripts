--BF－ツインシャドウ
function c69973414.initial_effect(c)
	aux.AddCodeList(c,9012916)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,69973414+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c69973414.cost)
	e1:SetTarget(c69973414.target)
	e1:SetOperation(c69973414.operation)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c69973414.handcon)
	c:RegisterEffect(e2)
end
function c69973414.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x33)
end
function c69973414.handcon(e)
	return Duel.IsExistingMatchingCard(c69973414.confilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
function c69973414.tdfilter(c)
	return c:IsSetCard(0x33) and c:IsType(TYPE_MONSTER) and c:GetLevel()>0
		and c:IsAbleToDeckOrExtraAsCost()
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c69973414.fselect(g,e,tp)
	return aux.gffcheck(g,Card.IsType,TYPE_TUNER,aux.NOT(Card.IsType),TYPE_TUNER)
		and Duel.IsExistingMatchingCard(c69973414.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g:GetSum(Card.GetLevel))
end
function c69973414.spfilter(c,e,tp,lv)
	return (c:IsSetCard(0x33) and c:IsType(TYPE_SYNCHRO) or c:IsCode(9012916)) and c:IsLevel(lv)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c69973414.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	local g=Duel.GetMatchingGroup(c69973414.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then
		return g:CheckSubGroup(c69973414.fselect,2,2,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,c69973414.fselect,false,2,2,e,tp)
	e:SetLabel(sg:GetSum(Card.GetLevel))
	Duel.HintSelection(sg)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c69973414.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c69973414.operation(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c69973414.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv):GetFirst()
	if tc then
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
			tc:CompleteProcedure()
		end
	end
end
