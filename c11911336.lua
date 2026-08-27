--大輪の魔導書
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--fusion
	local e2=FusionSpell.CreateSummonEffect(c,{
		fusion_spell_matfilter=s.fusion_spell_matfilter,
		stage_x_operation=s.stage_x_operation
	})
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(aux.bfgcost)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return c:IsSetCard(0xbf) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetAttribute)>=4 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,4,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetClassCount(Card.GetAttribute)<4 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.dabcheck,false,4,4)
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,sg)
		if sg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,2,2,nil)
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
function s.fusion_spell_matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFusionSetCard(0xbf,0x10c0)
end
function s.stage_x_operation(e,tc,tp,stage)
	if stage==FusionSpell.STAGE_BEFORE_MOVE_MATERIAL then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetLabelObject(tc)
		e1:SetCondition(s.sumcon)
		e1:SetOperation(s.sumop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_END)
		e2:SetLabelObject(e1)
		e2:SetOperation(s.cedop)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetLabelObject())
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(1)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(s.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(s.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(id)
	e:Reset()
end
function s.cedop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) and e:GetLabelObject():GetLabel()==1 and e:GetHandler():GetFlagEffect(id)~=0 then
		Duel.SetChainLimitTillChainEnd(s.chainlm)
	end
	e:GetHandler():ResetFlagEffect(id)
	e:Reset()
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
