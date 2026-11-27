--共命の翼ガルーラ
function c11765832.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c11765832.ffilter,2,true)
	--double damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_INVOLVING_BATTLE_DAMAGE)
	e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11765832,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,11765832)
	e2:SetTarget(c11765832.target)
	e2:SetOperation(c11765832.operation)
	c:RegisterEffect(e2)
end
function c11765832.matchfilter(c,attr,race)
	return c:IsFusionAttribute(attr) and c:IsRace(race)
end
function c11765832.ffilter(c,fc,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0
		or (sg:IsExists(c11765832.matchfilter,#sg-1,c,c:GetFusionAttribute(),c:GetRace())
			and not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c11765832.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11765832.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
