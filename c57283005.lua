--ハーピィ＆アマゾネス －羅刹の陣－
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,76812113,42443968)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsSetCard(0x64,0x4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.cfilter(c)
	return c:IsFaceup() and (c:IsCode(76812113) or c:IsSetCard(0x4) and c:IsType(TYPE_MONSTER))
end
function s.setfilter(c)
	return c:IsCode(42443968) and not c:IsForbidden()
end
function s.tgfilter(c)
	return c:IsControlerCanBeChanged()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and aux.NecroValleyFilter()(tc) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_ONFIELD,0,nil)
		local b1=ct>=1 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
		local b2=ct>=2 and Duel.IsExistingMatchingCard(s.tgfilter,tp,0,LOCATION_MZONE,1,nil)
		local b3=ct>=3 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
		if b1 or b2 or b3 then
			local op=aux.SelectFromOptions(tp,
				{b1,aux.Stringid(id,1),1},
				{b2,aux.Stringid(id,2),2},
				{b3,aux.Stringid(id,3),3},
				{true,aux.Stringid(id,4),4})
			if op==4 then return end
			Duel.BreakEffect()
			if op==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local sg=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
				Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			elseif op==2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
				local sg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
				local tgc=sg:GetFirst()
				if tgc then
					Duel.HintSelection(sg)
					Duel.GetControl(tgc,tp)
				end
			elseif op==3 then
				local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
end
