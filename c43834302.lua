--シンクロ・フェローズ
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddMaterialCodeList(c,63977008,60800381,44508094)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--lvdown
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.lvtg)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)
end
function s.thfilter1(c)
	return c:IsCode(63977008) and c:IsAbleToHand()
end
function s.thfilter2(c)
	return (aux.IsCodeListed(c,60800381) or aux.IsCodeListed(c,44508094)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thfilter(c)
	return (c:IsCode(63977008) or (aux.IsCodeListed(c,60800381) or aux.IsCodeListed(c,44508094)) and c:IsType(TYPE_MONSTER))
		and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		return g:CheckSubGroup(aux.gffcheck,2,2,s.thfilter1,nil,s.thfilter2,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if not g:CheckSubGroup(aux.gffcheck,2,2,s.thfilter1,nil,s.thfilter2,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg1=g:SelectSubGroup(tp,aux.gffcheck,false,2,2,s.thfilter1,nil,s.thfilter2,nil)
	if #tg1==2 then
		Duel.SendtoHand(tg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg1)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ShuffleHand(tp)
		Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
	end
end
function s.lvfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:GetLevel()>1 and c:IsFaceup()
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.lvfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,id)==0
		and Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and tc:GetLevel()>1
		and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) and Duel.GetFlagEffect(tp,id)==0 then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(id,2))
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
			e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
			e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1017))
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
