--トライエッジ・マスター
function c52445243.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,52445243)
	e1:SetCondition(c52445243.con)
	e1:SetTarget(c52445243.tg)
	e1:SetOperation(c52445243.op)
	c:RegisterEffect(e1)
	--material check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c52445243.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
c52445243.treat_itself_tuner=true
function c52445243.valcheck(e,c)
	e:GetLabelObject():SetLabel(0)
	local g=c:GetMaterial()
	if #g>=3 then
		e:GetLabelObject():SetLabel(1|2|4)
		return
	end
	local b1=g:IsExists(Card.IsLevel,1,nil,1) and g:IsExists(Card.IsLevel,1,nil,5)
	local b2=g:IsExists(Card.IsLevel,1,nil,2) and g:IsExists(Card.IsLevel,1,nil,4)
	local b3=g:IsExists(Card.IsLevel,2,nil,3)
	if b1 then
		e:GetLabelObject():SetLabel(1)
	end
	if b2 then
		e:GetLabelObject():SetLabel(2)
	end
	if b3 then
		e:GetLabelObject():SetLabel(4)
	end
end
function c52445243.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()~=0
end
function c52445243.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local des=ct&1>0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	local draw=ct&2>0 and Duel.IsPlayerCanDraw(tp,1)
	local tun=ct&4>0 and not c:IsType(TYPE_TUNER)
	if chk==0 then return des or draw or tun end
	e:SetCategory(0)
	if des then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
		e:SetCategory(CATEGORY_DESTROY)
	end
	if draw then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		e:SetCategory(e:GetCategory()|CATEGORY_DRAW)
	end
end
function c52445243.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local des=ct&1>0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,aux.ExceptThisCard(e))
	local draw=ct&2>0 and Duel.IsPlayerCanDraw(tp,1)
	local tun=ct&4>0 and not c:IsType(TYPE_TUNER) and c:IsRelateToChain() and c:IsFaceup()
	if des then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e))
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
		if draw or tun then Duel.BreakEffect() end
	end
	if draw then
		Duel.Draw(tp,1,REASON_EFFECT)
		if tun then Duel.BreakEffect() end
	end
	if tun then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
