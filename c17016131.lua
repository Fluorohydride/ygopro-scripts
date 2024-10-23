--海造賊－誇示
function c17016131.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17016131,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,17016131)
	e1:SetCondition(c17016131.drcon)
	e1:SetTarget(c17016131.drtg)
	e1:SetOperation(c17016131.drop)
	c:RegisterEffect(e1)
	--hand to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17016131,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,17016132)
	e2:SetCondition(c17016131.tgcond)
	e2:SetCost(c17016131.tgcost)
	e2:SetTarget(c17016131.tgtg)
	e2:SetOperation(c17016131.tgop)
	c:RegisterEffect(e2)
	--extra to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17016131,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,17016132)
	e3:SetCondition(c17016131.tgcond)
	e3:SetCost(c17016131.tgcost)
	e3:SetTarget(c17016131.tgtg2)
	e3:SetOperation(c17016131.tgop2)
	c:RegisterEffect(e3)
end
function c17016131.drcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	if not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then return end
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
		and rc:IsFaceup() and rc:IsSetCard(0x13f) and rc:IsControler(tp)
end
function c17016131.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c17016131.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c17016131.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x13f)
end
function c17016131.tgcond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
		and Duel.IsExistingMatchingCard(c17016131.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c17016131.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c17016131.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c17016131.tgfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c17016131.tgop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		local sg=g:Filter(c17016131.tgfilter1,nil)
		Duel.Hint(HINT_SELECTMSG,1-p,HINTMSG_TOGRAVE)
		local tg=sg:Select(1-p,1,1,nil)
		if tg:GetCount()>0 then
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
		Duel.ShuffleHand(p)
	end
end
function c17016131.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,1-tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c17016131.tgop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g)
	local tg=g:Filter(Card.IsAbleToGrave,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=tg:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	Duel.ShuffleExtra(1-tp)
end
