--地獄戦士
function c50916353.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50916353,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c50916353.damcon)
	e1:SetTarget(c50916353.damtg)
	e1:SetOperation(c50916353.damop)
	c:RegisterEffect(e1)
end
function c50916353.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==1 and e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c50916353.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local damage=Duel.GetBattleDamage(tp)
	if chk==0 then return damage>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(damage)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
end
function c50916353.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
