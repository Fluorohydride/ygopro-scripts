--人形の家
function c67331360.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67331360,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,67331360)
	e1:SetTarget(c67331360.sptg)
	e1:SetOperation(c67331360.spop)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67331360,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c67331360.matcon)
	e2:SetTarget(c67331360.mattg)
	e2:SetOperation(c67331360.matop)
	c:RegisterEffect(e2)
end
function c67331360.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and (c:IsAttack(0) or c:IsDefense(0)) and c:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c67331360.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode(),nil)
end
function c67331360.spfilter(c,e,tp,code,code2)
	return c:IsCode(code,code2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67331360.cfilter(c)
	return c:IsFaceup() and c:IsCode(75574498)
end
function c67331360.gcheck(sg,e,tp)
	if #sg==1 then return true end
	local code1=sg:GetFirst():GetCode()
	local code2=sg:GetNext():GetCode()
	local tg=Duel.GetMatchingGroup(c67331360.spfilter,tp,LOCATION_DECK,0,nil,e,tp,code1,code2)
	return tg:CheckSubGroup(aux.gfcheck,2,2,Card.IsCode,code1,code2)
end
function c67331360.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c67331360.filter(chkc,e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.IsExistingTarget(c67331360.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local ct=math.min(2,ft)
	if Duel.IsPlayerAffectedByEffect(tp,59822133)
		or not Duel.IsExistingMatchingCard(c67331360.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then ct=1 end
	local g=Duel.GetMatchingGroup(c67331360.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=g:SelectSubGroup(tp,c67331360.gcheck,false,1,ct,e,tp)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#tg,tp,LOCATION_DECK)
end
function c67331360.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local code1,code2
	local tc=tg:GetFirst()
	while tc do
		if Duel.IsExistingMatchingCard(c67331360.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,tc:GetCode(),nil) then
			if code1==nil then code1=tc:GetCode() else code2=tc:GetCode() end
		end
		tc=tg:GetNext()
	end
	if code1==nil then return end
	local sg
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or ft==1 or code2==nil then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=Duel.SelectMatchingCard(tp,c67331360.spfilter,tp,LOCATION_DECK,0,1,1,sg,e,tp,code1,code2)
	else
		local g=Duel.GetMatchingGroup(c67331360.spfilter,tp,LOCATION_DECK,0,nil,e,tp,code1,code2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsCode,code1,code2)
	end
	if not sg then return end
	local sc=sg:GetFirst()
	while sc do
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(sc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(6)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(sc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(ATTRIBUTE_DARK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2)
		sc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c67331360.matcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c67331360.matfilter(c)
	return c:IsCode(44190146) and c:IsFaceup() and c:IsCanOverlay()
end
function c67331360.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67331360.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c67331360.cfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c67331360.matop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c67331360.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g2=Duel.SelectMatchingCard(tp,c67331360.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g2:GetFirst()
		if tc and not tc:IsImmuneToEffect(e) and Duel.Overlay(tc,g1)~=0 then
			Duel.BreakEffect()
			Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		end
	end
end
