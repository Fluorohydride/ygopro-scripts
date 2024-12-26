--WW－ダイヤモンド・ベル
---@param c Card
function c73667937.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WIND),1)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73667937,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,73667937)
	e1:SetCondition(c73667937.damcon)
	e1:SetTarget(c73667937.damtg)
	e1:SetOperation(c73667937.damop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73667937,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c73667937.descon)
	e2:SetTarget(c73667937.destg)
	e2:SetOperation(c73667937.desop)
	c:RegisterEffect(e2)
	--material check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c73667937.matcon)
	e3:SetOperation(c73667937.matop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c73667937.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c73667937.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c73667937.damfilter(c)
	return c:IsSetCard(0xf0) and c:IsAttackAbove(1)
end
function c73667937.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c73667937.damfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c73667937.damfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c73667937.damfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.floor(g:GetFirst():GetAttack()/2))
end
function c73667937.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Damage(1-tp,math.floor(tc:GetAttack()/2),REASON_EFFECT)
	end
end
function c73667937.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c73667937.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() end
	if chk==0 then
		local b
		if c:GetFlagEffect(73667937)>0 then
			b=c:GetFlagEffect(73667938)<2
		else
			b=c:GetFlagEffect(73667938)<1
		end
		return b and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	c:RegisterFlagEffect(73667938,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c73667937.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c73667937.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function c73667937.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(73667937,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c73667937.mfilter(c)
	return not c:IsSetCard(0xf0)
end
function c73667937.valcheck(e,c)
	local g=c:GetMaterial()
	if #g>0 and not g:IsExists(c73667937.mfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
