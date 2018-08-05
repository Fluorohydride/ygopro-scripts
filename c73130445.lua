--EMリザードロー
function c73130445.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,73130445)
	e2:SetTarget(c73130445.destg)
	e2:SetOperation(c73130445.desop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,73130446)
	e3:SetCondition(c73130445.drcon)
	e3:SetTarget(c73130445.drtg)
	e3:SetOperation(c73130445.drop)
	c:RegisterEffect(e3)
end
function c73130445.desfilter(c)
	return c:IsSetCard(0x9f) and not c:IsCode(73130445)
end
function c73130445.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c73130445.desfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
		and e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c73130445.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c73130445.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp or c:IsReason(REASON_BATTLE) and c==Duel.GetAttackTarget())
end
function c73130445.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c73130445.cfilter,1,nil,tp)
end
function c73130445.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9f)
end
function c73130445.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c73130445.filter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c73130445.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c73130445.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
