--オーロラの天気模様
--Prototype, might require a core update for full functionality
function c52834429.initial_effect(c)
	c:SetUniqueOnField(1,0,52834429)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c52834429.effop)
	c:RegisterEffect(e2)
end
function c52834429.efffilter(c,g,ignore_flag)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsSetCard(0x109)
		and c:GetSequence()<5 and g:IsContains(c) and (ignore_flag or c:GetFlagEffect(52834429)==0)
end
function c52834429.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup(1,1)
	local g=Duel.GetMatchingGroup(c52834429.efffilter,tp,LOCATION_MZONE,0,nil,cg)
	if c:IsDisabled() then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(52834429,RESET_EVENT+0x1fe0000,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(52834429,0))
		e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetLabelObject(c)
		e1:SetCondition(c52834429.rmcon)
		e1:SetCost(aux.bfgcost)
		e1:SetTarget(c52834429.rmtg)
		e1:SetOperation(c52834429.rmop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c52834429.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1
end
function c52834429.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local gc=e:GetLabelObject()
	local ec=eg:GetFirst()
	if chk==0 then return gc and gc:IsFaceup() and gc:IsLocation(LOCATION_SZONE)
		and not gc:IsDisabled() and c52834429.efffilter(c,gc:GetColumnGroup(1,1),true)
		and ec and ec:IsAbleToRemove() and Duel.IsPlayerCanDraw(ec:GetControler(),1) end
	local htp=ec:GetControler()
	Duel.SetTargetPlayer(htp)
	Duel.SetTargetParam(1)
	e:SetLabelObject(ec)
	ec:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,ec,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,htp,1)
end
function c52834429.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
