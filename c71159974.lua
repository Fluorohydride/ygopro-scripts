--魔鍵召竜－アンドラビムス
---@param c Card
function c71159974.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c71159974.mtfilter,c71159974.mtfilter2,true)
	--different attr check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c71159974.valcheck)
	c:RegisterEffect(e0)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c71159974.limcon)
	e1:SetOperation(c71159974.limop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetOperation(c71159974.limop2)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71159974,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c71159974.destg)
	e3:SetOperation(c71159974.desop)
	c:RegisterEffect(e3)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(71159974,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c71159974.drcon)
	e4:SetTarget(c71159974.drtg)
	e4:SetOperation(c71159974.drop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c71159974.matcon)
	e5:SetOperation(c71159974.matop)
	c:RegisterEffect(e5)
	e0:SetLabelObject(e5)
end
function c71159974.mtfilter(c)
	return c:IsFusionSetCard(0x165) and c:IsFusionType(TYPE_EFFECT)
end
function c71159974.mtfilter2(c)
	return c:IsFusionType(TYPE_NORMAL) and not c:IsType(TYPE_TOKEN)
end
function c71159974.attfilter(c,rc)
	return c:GetAttribute()>0
end
function c71159974.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(c71159974.attfilter,nil,c)
	if fg:GetClassCount(Card.GetAttribute)==2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c71159974.limcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c71159974.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c71159974.chlimit)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(71159974,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c71159974.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c71159974.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(71159974)
	e:Reset()
end
function c71159974.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(71159974)~=0 then
		Duel.SetChainLimitTillChainEnd(c71159974.chlimit)
	end
	e:GetHandler():ResetFlagEffect(71159974)
end
function c71159974.chlimit(e,ep,tp)
	return tp==ep
end
function c71159974.ckfilter(c,tp)
	return (c:IsType(TYPE_NORMAL) or c:IsSetCard(0x165) and c:IsType(TYPE_MONSTER))
		and Duel.IsExistingMatchingCard(c71159974.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttribute())
end
function c71159974.desfilter(c,at)
	return c:IsFaceup() and c:IsAttribute(at)
end
function c71159974.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c71159974.ckfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c71159974.ckfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c71159974.ckfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	local tg=Duel.GetMatchingGroup(c71159974.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,tg:GetCount(),0,0)
end
function c71159974.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c71159974.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c71159974.drfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
		and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,0,LOCATION_GRAVE,1,nil,c:GetAttribute())
end
function c71159974.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71159974.drfilter,1,nil,1-tp) and e:GetHandler():GetFlagEffect(71159975)~=0
end
function c71159974.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c71159974.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c71159974.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()==1
end
function c71159974.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(71159975,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71159974,2))
end
