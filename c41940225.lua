--破壊剣士融合
function c41940225.initial_effect(c)
	--Activate
	local e1=aux.AddFusionEffectProcUltimate(c,{
		filter=c41940225.filter,
		get_extra_mat=c41940225.get_extra_mat,
		get_fcheck=c41940225.get_fcheck
	})
	e1:SetDescription(aux.Stringid(41940225,0))
	e1:SetCountLimit(1,41940225)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(41940225,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,41940226)
	e2:SetCost(c41940225.thcost)
	e2:SetTarget(c41940225.thtg)
	e2:SetOperation(c41940225.thop)
	c:RegisterEffect(e2)
end
function c41940225.filter(c)
	return aux.IsMaterialListCode(c,78193831)
end
function c41940225.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c41940225.get_extra_mat(e,tp)
	return Duel.GetMatchingGroup(c41940225.filter1,tp,0,LOCATION_MZONE,nil,e)
end
function c41940225.get_fcheck(fc)
	return fc.destruction_swordsman_fusion_check or c41940225.fcheck
end
function c41940225.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionCode,1,nil,78193831)
end
function c41940225.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function c41940225.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c41940225.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
